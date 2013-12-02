//
//  ttDealAcquire.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/22/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolDealAcquire.h"

@class DealAcquire_t, ttMerchant, ttFriend, ttCustomer;

@interface ttDealAcquire : TaloolDealAcquire

+ (ttDealAcquire *)initWithThrift: (DealAcquire_t *)deal merchant:(ttMerchant *)merchant context:(NSManagedObjectContext *)context;
+ (ttDealAcquire *)initWithThrift: (DealAcquire_t *)deal context:(NSManagedObjectContext *)context;
+ (ttDealAcquire *) fetchDealAcquireById:(NSString *) dealAcquireId context:(NSManagedObjectContext *)context;

- (BOOL) hasBeenRedeemed;
- (BOOL) hasBeenShared;
- (BOOL) hasExpired;

- (BOOL) redeemHere:(ttCustomer *)customer latitude:(double)latitude longitude:(double)longitude error:(NSError**)error context:(NSManagedObjectContext *)context;
- (BOOL) setSharedWith:(ttFriend *)taloolFriend error:(NSError**)error context:(NSManagedObjectContext *)context;
+ (BOOL) getDealAcquires:(ttCustomer *)customer forMerchant:(ttMerchant *)merchant context:(NSManagedObjectContext *)context error:(NSError **)err;

@end
