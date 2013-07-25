//
//  TaloolCustomer.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/6/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolCustomerUX, TaloolDealAcquire, TaloolToken, ttMerchant, ttSocialAccount;

@interface TaloolCustomer : NSManagedObject

@property (nonatomic, retain) NSDate * birthDate;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * customerId;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSSet *merchants;
@property (nonatomic, retain) NSSet *socialAccounts;
@property (nonatomic, retain) TaloolToken *token;
@property (nonatomic, retain) TaloolCustomerUX *ux;
@end

@interface TaloolCustomer (CoreDataGeneratedAccessors)

- (void)addMerchantsObject:(ttMerchant *)value;
- (void)removeMerchantsObject:(ttMerchant *)value;
- (void)addMerchants:(NSSet *)values;
- (void)removeMerchants:(NSSet *)values;

- (void)addSocialAccountsObject:(ttSocialAccount *)value;
- (void)removeSocialAccountsObject:(ttSocialAccount *)value;
- (void)addSocialAccounts:(NSSet *)values;
- (void)removeSocialAccounts:(NSSet *)values;

@end
