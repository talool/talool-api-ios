//
//  ttMerchant.h
//  mobile
//
//  Created by Douglas McCuen on 3/2/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolMerchant.h"

@class Merchant_t;

@interface ttMerchant : TaloolMerchant

- (BOOL)isValid;
+ (ttMerchant *)initWithThrift: (Merchant_t *)merchant context:(NSManagedObjectContext *)context;
- (Merchant_t *)hydrateThriftObject;
- (NSSet *) getDeals: (NSManagedObjectContext *)context;

@end
