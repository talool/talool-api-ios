//
//  ttCoupon.h
//  mobile
//
//  Created by Douglas McCuen on 3/3/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolDeal.h"

@class Deal_t, ttMerchant;

@interface ttDeal : TaloolDeal

+ (ttDeal *)initWithThrift: (Deal_t *)deal merchant:(ttMerchant *)merchant context:(NSManagedObjectContext *)context;
- (Deal_t *)hydrateThriftObject;

@end
