//
//  TaloolDeal.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/22/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolDealAcquire, TaloolMerchant;

@interface TaloolDeal : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * dealId;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSDate * expires;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * redeemed;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) TaloolMerchant *merchant;
@property (nonatomic, retain) TaloolDealAcquire *acquires;

@end
