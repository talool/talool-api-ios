//
//  TaloolGiftDetail.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/19/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ttDealAcquire;

@interface TaloolGiftDetail : NSManagedObject

@property (nonatomic, retain) NSString * giftId;
@property (nonatomic, retain) NSDate * giftedTime;
@property (nonatomic, retain) NSString * fromName;
@property (nonatomic, retain) NSString * fromEmail;
@property (nonatomic, retain) NSString * toName;
@property (nonatomic, retain) NSString * toEmail;
@property (nonatomic, retain) ttDealAcquire *dealAcquire;

@end
