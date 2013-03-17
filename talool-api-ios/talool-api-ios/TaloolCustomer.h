//
//  TaloolCustomer.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/16/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolToken, ttSocialAccount;

@interface TaloolCustomer : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSNumber * customerId;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSSet *socialAccounts;
@property (nonatomic, retain) TaloolToken *token;
@end

@interface TaloolCustomer (CoreDataGeneratedAccessors)

- (void)addSocialAccountsObject:(ttSocialAccount *)value;
- (void)removeSocialAccountsObject:(ttSocialAccount *)value;
- (void)addSocialAccounts:(NSSet *)values;
- (void)removeSocialAccounts:(NSSet *)values;

@end
