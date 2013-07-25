//
//  TaloolDealAcquire.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/6/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolCustomer, ttDeal, ttFriend;

@interface TaloolDealAcquire : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * dealAcquireId;
@property (nonatomic, retain) NSString * redemptionCode;
@property (nonatomic, retain) NSDate * redeemed;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSDate * shared;
@property (nonatomic, retain) NSDate * invalidated;
@property (nonatomic, retain) ttDeal *deal;
@property (nonatomic, retain) ttFriend *sharedTo;

@end
