//
//  TaloolGift.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/4/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolCustomer, TaloolDeal;

@interface TaloolGift : NSManagedObject

@property (nonatomic, retain) NSString * giftId;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) TaloolDeal *deal;
@property (nonatomic, retain) TaloolCustomer *fromCustomer;

@end
