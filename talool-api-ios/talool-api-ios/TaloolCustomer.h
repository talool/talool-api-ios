//
//  TaloolCustomer.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/15/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SocialAccount;

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
@end

@interface TaloolCustomer (CoreDataGeneratedAccessors)

- (void)addSocialAccountsObject:(SocialAccount *)value;
- (void)removeSocialAccountsObject:(SocialAccount *)value;
- (void)addSocialAccounts:(NSSet *)values;
- (void)removeSocialAccounts:(NSSet *)values;

@end
