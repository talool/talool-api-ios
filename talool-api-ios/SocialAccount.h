//
//  SocialAccount.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/4/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolCustomer;

@interface SocialAccount : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * loginId;
@property (nonatomic, retain) NSNumber * socialNetwork;
@property (nonatomic, retain) TaloolCustomer *customersocialaccount;

@end
