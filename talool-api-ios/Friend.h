//
//  Friend.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/6/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolGift,TaloolDealAcquire;

@interface Friend : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * customerId;
@property (nonatomic, retain) TaloolGift *giftsGiven;
@property (nonatomic, retain) TaloolDealAcquire *giftsReceived;

@end
