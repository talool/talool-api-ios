//
//  ttDealOffer.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/15/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttDealOffer.h"
#import "ttMerchant.h"
#import "ttDeal.h"
#import "Core.h"
#import "Property.h"
#import "DealOfferController.h"
#import "TaloolPersistentStoreCoordinator.h"
#import <APIErrorManager.h>

@implementation ttDealOffer

#pragma mark -
#pragma mark - Create or Update the Core Data Object

+ (ttDealOffer *)initWithThrift: (DealOffer_t *)offer context:(NSManagedObjectContext *)context
{
    ttDealOffer *newOffer = [ttDealOffer fetchById:offer.dealOfferId context:context];
    
    newOffer.code = offer.code;
    newOffer.dealOfferId = offer.dealOfferId;
    newOffer.title = offer.title;
    newOffer.summary = offer.summary;
    newOffer.dealType = [[NSNumber alloc] initWithUnsignedInteger:offer.dealType];
    newOffer.imageUrl = offer.imageUrl;
    
    NSDictionary *props = offer.properties;
    NSString* fundraisingBook = [props objectForKey:PropertyConstants.FUNDRAISING_BOOK];
    newOffer.fundraiser = [NSNumber numberWithBool:[fundraisingBook isEqualToString:@"true"]];
    
    if (offer.dealOfferMerchantLogoIsSet)
    {
        newOffer.iconUrl = offer.dealOfferMerchantLogo;
    }
    
    if (offer.dealOfferBackgroundImageIsSet)
    {
        newOffer.backgroundUrl = offer.dealOfferBackgroundImage;
    }
    
    newOffer.locationName = offer.locationName;
    newOffer.price = [[NSNumber alloc] initWithDouble:offer.price];
    newOffer.merchant = [ttMerchant initWithThrift:offer.merchant context:context];

    
    // The expires date is meaningless now that we have scheduling,
    // but I am using it to hide deals rather than deleting them.
    // Here I set the expires date to 1 year from now, so all offers
    // coming from the service show up.
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:1];
    NSDate *oneYearFromNow = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    newOffer.expires = oneYearFromNow;
    
    return newOffer;
}

+ (ttDealOffer *) fetchById:(NSString *) entityId context:(NSManagedObjectContext *)context
{
    ttDealOffer *offer = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.dealOfferId = %@",entityId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:DEAL_OFFER_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    
    if (fetchedObj == nil || [fetchedObj count] == 0)
    {
        offer = (ttDealOffer *)[NSEntityDescription
                          insertNewObjectForEntityForName:DEAL_OFFER_ENTITY_NAME
                          inManagedObjectContext:context];
    }
    else
    {
        offer = [fetchedObj objectAtIndex:0];
    }
    return offer;
}

+ (BOOL) getById:(NSString *)dealOfferId
                 customer:(ttCustomer *)customer
                  context:(NSManagedObjectContext *)context
                    error:(NSError **)error
{
    BOOL result = NO;
    
    DealOfferController *doc = [[DealOfferController alloc] init];
    DealOffer_t *offer = [doc getDealOfferById:dealOfferId customer:customer error:error];
    if (offer)
    {
        [ttDealOffer initWithThrift:offer context:context];
        result = [context save:error];
    }
    
    return result;
}


#pragma mark -
#pragma mark - Convenience Methods

- (BOOL) isFundraiser
{
    return ([self.fundraiser intValue] == 1);
}

+ (void) expireAll:(NSManagedObjectContext *)context
{
    // Deleting objects makes was causing problems, so I'm now just expiring
    // all deals before the service fetches the current set.
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-1];
    NSDate *oneMonthAgo = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:DEAL_OFFER_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedSet = [context executeFetchRequest:request error:&error];
    
    if (fetchedSet != nil && [fetchedSet count] > 0 && error == nil)
    {
        for (ttDealOffer *offer in fetchedSet)
        {
            offer.expires = oneMonthAgo;
        }
        [context save:&error];
    }
    
}

- (BOOL) isFree
{
    /*
     Based on DealType_t.java in talool-thrift...
     PAID_BOOK(0),
     FREE_BOOK(1),
     PAID_DEAL(2),
     FREE_DEAL(3);
     */
    return ([self.dealType intValue]==1 ||
            [self.dealType intValue]==3 ||
            [self.price doubleValue] <= 0
            );
}


#pragma mark -
#pragma mark - Get the Deals for the Deal Offer

- (BOOL)getDeals:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)err
{
    BOOL result = NO;
    
    DealOfferController *doc = [[DealOfferController alloc] init];
    NSArray *deals = [doc getDealsByDealOfferId:self.dealOfferId customer:customer error:err];
    
    if (deals)
    {
        @try {
            // transform the Thrift response into a ttDealAcquire array
            for (int i=0; i<[deals count]; i++)
            {
                Deal_t *td = [deals objectAtIndex:i];
                [ttDeal initWithThrift:td merchant:nil context:context];
            }
            // save the context
            result = [context save:err];
        }
        @catch (NSException * e) {
            [doc.errorManager handleCoreDataException:e forMethod:@"getDealByDealOfferId" entity:@"ttDeal" error:err];
        }
    }
    
    return result;
}


#pragma mark -
#pragma mark - Activate or Purchase the Deal Offer

- (int)validateCode:(ttCustomer *)customer code:(NSString *)code error:(NSError **)err
{
    DealOfferController *doc = [[DealOfferController alloc] init];
    return [doc validateCode:customer offerId:self.dealOfferId code:code error:err];
}

- (BOOL)activiateCode:(ttCustomer *)customer code:(NSString *)code error:(NSError **)err
{
    DealOfferController *doc = [[DealOfferController alloc] init];
    return [doc activateCode:customer offerId:self.dealOfferId code:code error:err];
}

- (BOOL) purchaseWithNonce:(NSString *)nonce
                  customer:(ttCustomer *)customer
                fundraiser:(NSString *)fundraiser
                     error:(NSError**)error
{
    DealOfferController *doc = [[DealOfferController alloc] init];
    return [doc purchaseWithNonce:self.dealOfferId nonce:nonce customer:customer fundraiser:fundraiser error:error];
}


@end
