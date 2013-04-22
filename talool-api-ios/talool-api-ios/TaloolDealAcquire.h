//
//  TaloolDealAcquire.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/22/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolCustomer, TaloolDeal, TaloolMerchant;

@interface TaloolDealAcquire : NSManagedObject

@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSString * dealAcquireId;
@property (nonatomic, retain) NSNumber * shareCount;
@property (nonatomic, retain) NSDate * redeemed;
@property (nonatomic, retain) TaloolDeal *deal;
@property (nonatomic, retain) TaloolMerchant *sharedByMerchant;
@property (nonatomic, retain) TaloolCustomer *sharedByCustomer;
@property (nonatomic, retain) TaloolCustomer *customer;

@end
