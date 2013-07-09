//
//  ttDealOffer.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/15/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttDealOffer.h"
#import "ttMerchant.h"
#import "Core.h"
#import "CustomerController.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttDealOffer

+ (ttDealOffer *)initWithThrift: (DealOffer_t *)offer context:(NSManagedObjectContext *)context
{
    ttDealOffer *newOffer = (ttDealOffer *)[NSEntityDescription
                                               insertNewObjectForEntityForName:DEAL_OFFER_ENTITY_NAME
                                               inManagedObjectContext:context];
    
    newOffer.code = offer.code;
    newOffer.dealOfferId = offer.dealOfferId;
    newOffer.title = offer.title;
    newOffer.summary = offer.summary;
    newOffer.dealType = [[NSNumber alloc] initWithUnsignedInteger:offer.dealType];
    newOffer.imageUrl = offer.imageUrl;
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

+ (ttDealOffer *)getDealOffer:(NSString *)doId
                     customer:(ttCustomer *)customer
                      context:(NSManagedObjectContext *)context
                        error:(NSError **)err
{
    ttDealOffer *offer;
    
    // check the context before going to the service
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.dealOfferId = %@",doId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:DEAL_OFFER_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if ([mutableFetchResults count] == 1)
    {
        offer = [mutableFetchResults objectAtIndex:0];
    }
    else
    {
        CustomerController *cc = [[CustomerController alloc] init];
        offer = [cc getDealOffer:doId customer:customer context:context error:err];
    }
    return offer;
}

+ (NSArray *)getDealOffers:(ttCustomer *)customer
                   context:(NSManagedObjectContext *)context
                     error:(NSError **)err
{
    NSArray *offers;
    
    // TODO pull from context first
    CustomerController *cc = [[CustomerController alloc] init];
    offers = [cc getDealOffers:customer context:context error:err];
    
    return offers;
}

- (NSArray *)getDeals:(ttCustomer *)customer
              context:(NSManagedObjectContext *)context
                error:(NSError **)err
{
    NSArray *deals;
    
    // TODO pull from context first
    CustomerController *cc = [[CustomerController alloc] init];
    deals = [cc getDealsByDealOfferId:self.dealOfferId customer:customer context:context error:err];
    
    return deals;
}

- (BOOL)activiateCode:(ttCustomer *)customer code:(NSString *)code error:(NSError **)err
{
    CustomerController *cc = [[CustomerController alloc] init];
    return [cc activateCode:customer offerId:self.dealOfferId code:code error:err];
}


- (DealOffer_t *)hydrateThriftObject
{
    DealOffer_t *offer = [[DealOffer_t alloc] init];
    offer.code = self.code;
    offer.dealOfferId = self.dealOfferId;
    offer.title = self.title;
    offer.summary = self.summary;
    offer.dealType = [self.dealType intValue];
    offer.imageUrl = self.imageUrl;
    offer.locationName = self.locationName;
    offer.price = [self.price doubleValue];
    offer.merchant = [(ttMerchant *)self.merchant hydrateThriftObject];
    
    return offer;
}

@end
