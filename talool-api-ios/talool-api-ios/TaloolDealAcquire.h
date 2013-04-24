//
//  TaloolDealAcquire.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/24/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolDeal;

@interface TaloolDealAcquire : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * dealAcquireId;
@property (nonatomic, retain) NSDate * redeemed;
@property (nonatomic, retain) NSNumber * shareCount;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) TaloolDeal *deal;

@end
