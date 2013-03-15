//
//  SocialAccount.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/15/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolCustomer;

@interface SocialAccount : NSManagedObject

@property (nonatomic, retain) NSString * apiUrl;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * loginId;
@property (nonatomic, retain) NSNumber * socialNetwork;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) TaloolCustomer *customersocialaccount;

@end
