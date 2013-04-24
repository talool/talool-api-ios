//
//  ttDealAcquire.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/22/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolDealAcquire.h"

@class DealAcquire_t, ttCustomer;

@interface ttDealAcquire : TaloolDealAcquire

@property (nonatomic, retain) ttCustomer *customer;

+ (ttDealAcquire *)initWithThrift: (DealAcquire_t *)deal context:(NSManagedObjectContext *)context;
- (DealAcquire_t *)hydrateThriftObject;
- (BOOL) hasBeenRedeemed;
- (void)redeemHere:(double)latitude longitude:(double)longitude error:(NSError**)error;

@end
