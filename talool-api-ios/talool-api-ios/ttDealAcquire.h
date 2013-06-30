//
//  ttDealAcquire.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/22/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolDealAcquire.h"

@class DealAcquire_t, ttCustomer, ttMerchant, ttFriend;

@interface ttDealAcquire : TaloolDealAcquire

@property (nonatomic, retain) ttCustomer *customer;

+ (ttDealAcquire *)initWithThrift: (DealAcquire_t *)deal merchant:(ttMerchant *)merchant context:(NSManagedObjectContext *)context;
+ (ttDealAcquire *)initWithThrift: (DealAcquire_t *)deal context:(NSManagedObjectContext *)context;
- (DealAcquire_t *)hydrateThriftObject;
- (BOOL) hasBeenRedeemed;
- (BOOL) hasBeenShared;
- (BOOL) hasExpired;
- (NSString *)redeemHere:(double)latitude longitude:(double)longitude error:(NSError**)error context:(NSManagedObjectContext *)context;
- (void) setSharedWith:(ttFriend *)taloolFriend;

@end
