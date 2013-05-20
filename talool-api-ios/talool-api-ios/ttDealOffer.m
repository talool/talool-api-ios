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
    newOffer.expires = [[NSDate alloc] initWithTimeIntervalSince1970:offer.expires];
    newOffer.price = [[NSNumber alloc] initWithDouble:offer.price];
    newOffer.merchant = [ttMerchant initWithThrift:offer.merchant context:context];
    
    return newOffer;
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
    offer.expires = [self.expires timeIntervalSince1970];
    offer.price = [self.price doubleValue];
    offer.merchant = [(ttMerchant *)self.merchant hydrateThriftObject];
    
    return offer;
}

@end