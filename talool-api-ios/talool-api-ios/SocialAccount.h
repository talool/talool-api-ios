//
//  SocialAccount.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/22/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolCustomer;

@interface SocialAccount : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * loginId;
@property (nonatomic, retain) NSNumber * socialNetwork;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) TaloolCustomer *customersocialaccount;

@end
