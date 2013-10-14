//
//  TaloolGift.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/6/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Friend, ttDeal;

@interface TaloolGift : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * giftId;
@property (nonatomic, retain) ttDeal *deal;
@property (nonatomic, retain) Friend *fromCustomer;

@end
