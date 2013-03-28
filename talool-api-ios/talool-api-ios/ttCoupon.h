//
//  ttCoupon.h
//  mobile
//
//  Created by Douglas McCuen on 3/3/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolDeal.h"

@interface ttCoupon : TaloolDeal

//+ (ttDeal *)initWithThrift: (Deal_t *)deal context:(NSManagedObjectContext *)context;
//- (Deal_t *)hydrateThriftObject;
+ (ttCoupon *)initWithName:(NSString *)name  context:(NSManagedObjectContext *)context;
- (BOOL) hasBeenRedeemed;

@end
