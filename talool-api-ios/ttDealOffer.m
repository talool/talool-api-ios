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


#pragma mark -
#pragma mark - Get the Deals for the Deal Offer

- (BOOL)getDeals:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)err
{
    BOOL result = NO;
    err = nil;
    
    DealOfferController *doc = [[DealOfferController alloc] init];
    NSArray *deals = [doc getDealsByDealOfferId:self.dealOfferId customer:customer error:err];
    
    if (!err)
    {
        @try {
            // transform the Thrift response into a ttDealAcquire array
            for (int i=0; i<[deals count]; i++)
            {
                Deal_t *td = [deals objectAtIndex:i];
                [ttDeal initWithThrift:td merchant:nil context:context];
            }
            // save the context
            if ([context save:err])
            {
                result = YES;
            }
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
    err = nil;
    DealOfferController *doc = [[DealOfferController alloc] init];
    return [doc activateCode:customer offerId:self.dealOfferId code:code error:err];
}

- (BOOL) purchaseByCard:(NSString *)card
               expMonth:(NSString *)expMonth
                expYear:(NSString *)expYear
           securityCode:(NSString *)securityCode
                zipCode:(NSString *)zipCode
           venmoSession:(NSString *)venmoSession
               customer:(ttCustomer *)customer
                  error:(NSError**)error
{
    error = nil;
    DealOfferController *doc = [[DealOfferController alloc] init];
    return [doc purchaseByCard:self.dealOfferId card:card expMonth:expMonth expYear:expYear securityCode:securityCode zipCode:zipCode venmoSession:venmoSession customer:customer error:error];
}

- (BOOL) purchaseByCode:(NSString *)paymentCode
               customer:(ttCustomer *)customer
                  error:(NSError**)error
{
    error = nil;
    DealOfferController *doc = [[DealOfferController alloc] init];
    return [doc purchaseByCode:self.dealOfferId paymentCode:paymentCode customer:customer error:error];
}


@end
