//
//  ttGift.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/4/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttGift.h"
#import "ttCustomer.h"
#import "ttDeal.h"
#import "ttMerchant.h"
#import "ttDealAcquire.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttGift

+ (ttGift *)initWithThrift: (Gift_t *)gift context:(NSManagedObjectContext *)context
{
    ttGift *newGift = (ttGift *)[NSEntityDescription
                                 insertNewObjectForEntityForName:GIFT_ENTITY_NAME
                                 inManagedObjectContext:context];

    newGift.giftId = gift.giftId;
    newGift.created = [[NSDate alloc] initWithTimeIntervalSince1970:(gift.created/1000)];
    ttMerchant *merch = [ttMerchant initWithThrift:gift.deal.merchant context:context];
    newGift.deal = [ttDeal initWithThrift:gift.deal merchant:merch context:context];
    newGift.fromCustomer = [ttCustomer initWithThrift:gift.fromCustomer context:context];
    
    return newGift;
}

- (Gift_t *)hydrateThriftObject
{
    Gift_t *gift = [[Gift_t alloc] init];
    
    gift.giftId = self.giftId;
    gift.deal = [(ttDeal *)self.deal hydrateThriftObject];
    gift.fromCustomer = [(ttCustomer *)self.fromCustomer hydrateThriftObject];
    
    return gift;
}

@end
