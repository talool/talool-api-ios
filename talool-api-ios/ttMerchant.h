//
//  ttMerchant.h
//  mobile
//
//  Created by Douglas McCuen on 3/2/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolMerchant.h"

@class Merchant_t, ttCustomer, ttMerchantLocation, ttLocation;

@interface ttMerchant : TaloolMerchant



+ (ttMerchant *)initWithThrift: (Merchant_t *)merchant context:(NSManagedObjectContext *)context;
- (Merchant_t *)hydrateThriftObject;
- (NSString *)getLocationLabel;
- (void)favorite:(ttCustomer *)customer;
- (void)unfavorite:(ttCustomer *)customer;
- (Boolean) isFavorite;

- (ttMerchantLocation *) getClosestLocation;

+ (ttMerchant *) fetchMerchantById:(NSString *) merchantId context:(NSManagedObjectContext *)context;
+ (NSArray *) getMerchantsInContext:(NSManagedObjectContext *)context;

@end