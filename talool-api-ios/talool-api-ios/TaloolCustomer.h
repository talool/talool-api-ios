//
//  TaloolCustomer.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/24/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolMerchant, ttSocialAccount, ttToken;

@interface TaloolCustomer : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * customerId;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSSet *merchants;
@property (nonatomic, retain) NSSet *socialAccounts;
@property (nonatomic, retain) ttToken *token;
@end

@interface TaloolCustomer (CoreDataGeneratedAccessors)

- (void)addMerchantsObject:(TaloolMerchant *)value;
- (void)removeMerchantsObject:(TaloolMerchant *)value;
- (void)addMerchants:(NSSet *)values;
- (void)removeMerchants:(NSSet *)values;

- (void)addSocialAccountsObject:(ttSocialAccount *)value;
- (void)removeSocialAccountsObject:(ttSocialAccount *)value;
- (void)addSocialAccounts:(NSSet *)values;
- (void)removeSocialAccounts:(NSSet *)values;

@end
