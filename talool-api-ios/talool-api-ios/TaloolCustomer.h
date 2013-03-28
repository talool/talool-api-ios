//
//  TaloolCustomer.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/28/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Friend, TaloolMerchant, ttSocialAccount, ttToken;

@interface TaloolCustomer : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSNumber * customerId;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) NSSet *socialAccounts;
@property (nonatomic, retain) ttToken *token;
@property (nonatomic, retain) NSSet *favoriteMerchants;
@end

@interface TaloolCustomer (CoreDataGeneratedAccessors)

- (void)addFriendsObject:(Friend *)value;
- (void)removeFriendsObject:(Friend *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

- (void)addSocialAccountsObject:(ttSocialAccount *)value;
- (void)removeSocialAccountsObject:(ttSocialAccount *)value;
- (void)addSocialAccounts:(NSSet *)values;
- (void)removeSocialAccounts:(NSSet *)values;

- (void)addFavoriteMerchantsObject:(TaloolMerchant *)value;
- (void)removeFavoriteMerchantsObject:(TaloolMerchant *)value;
- (void)addFavoriteMerchants:(NSSet *)values;
- (void)removeFavoriteMerchants:(NSSet *)values;

@end
