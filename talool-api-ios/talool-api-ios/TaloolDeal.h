//
//  TaloolDeal.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/27/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolMerchant;

@interface TaloolDeal : NSManagedObject

@property (nonatomic, retain) NSString * artworkUrl;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * redeemed;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) TaloolMerchant *merchant;

@end
