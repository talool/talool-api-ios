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
    
#warning "set the fundraiser property"
    newOffer.fundraiser = [NSNumber numberWithBool:NO];
    
    if (offer.dealOfferMerchantLogoIsSet)
    {
        newOffer.iconUrl = offer.dealOfferMerchantLogo;
    }
    
    if (offer.dealOfferBackgroundImageIsSet)
    {
        newOffer.backgroundUrl = offer.dealOfferBackgroundImage;
    }
    
    newOffer.locationName = offer.locationName;
    
    if (offer.expires==0)
    {
        newOffer.expires = nil;
    }
    else
    {
        newOffer.expires = [[NSDate alloc] initWithTimeIntervalSince1970:(offer.expires/1000)];
    }
    newOffer.price = [[NSNumber alloc] initWithDouble:offer.price];
    newOffer.merchant = [ttMerchant initWithThrift:offer.merchant context:context];
    
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

- (BOOL)activiateCode:(ttCustomer *)customer code:(NSString *)code error:(NSError **)err
{
    DealOfferController *doc = [[DealOfferController alloc] init];
    return [doc activateCode:customer offerId:self.dealOfferId code:code error:err];
}

- (BOOL)validateCode:(ttCustomer *)customer code:(NSString *)code error:(NSError **)err
{
    DealOfferController *doc = [[DealOfferController alloc] init];
    return [doc validateCode:customer code:code error:err];
}

- (BOOL) purchaseByCard:(NSString *)card
               expMonth:(NSString *)expMonth
                expYear:(NSString *)expYear
           securityCode:(NSString *)securityCode
                zipCode:(NSString *)zipCode
           venmoSession:(NSString *)venmoSession
               customer:(ttCustomer *)customer
             fundraiser:(NSString *)fundraiser
                  error:(NSError**)error
{
    DealOfferController *doc = [[DealOfferController alloc] init];
    return [doc purchaseByCard:self.dealOfferId card:card expMonth:expMonth expYear:expYear securityCode:securityCode zipCode:zipCode venmoSession:venmoSession customer:customer fundraiser:fundraiser error:error];
}

- (BOOL) purchaseByCode:(NSString *)paymentCode
               customer:(ttCustomer *)customer
             fundraiser:(NSString *)fundraiser
                  error:(NSError**)error
{
    DealOfferController *doc = [[DealOfferController alloc] init];
    return [doc purchaseByCode:self.dealOfferId paymentCode:paymentCode customer:customer fundraiser:fundraiser error:error];
}


@end
