//
//  TaloolDeal.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/5/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolDealAcquire, ttGift, ttMerchant;

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
@property (nonatomic, retain) NSString * dealOfferId;
@property (nonatomic, retain) TaloolDealAcquire *acquires;
@property (nonatomic, retain) ttGift *gift;
@property (nonatomic, retain) ttMerchant *merchant;

@end
