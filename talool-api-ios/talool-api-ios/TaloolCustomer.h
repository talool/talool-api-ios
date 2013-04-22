//
//  TaloolCustomer.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/22/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolDealAcquire, TaloolMerchant, TaloolToken, ttSocialAccount;

@interface TaloolCustomer : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * customerId;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSSet *socialAccounts;
@property (nonatomic, retain) NSSet *deals;
@property (nonatomic, retain) TaloolDealAcquire *shares;
@property (nonatomic, retain) TaloolToken *token;
@property (nonatomic, retain) NSSet *merchants;
@end

@interface TaloolCustomer (CoreDataGeneratedAccessors)

- (void)addSocialAccountsObject:(ttSocialAccount *)value;
- (void)removeSocialAccountsObject:(ttSocialAccount *)value;
- (void)addSocialAccounts:(NSSet *)values;
- (void)removeSocialAccounts:(NSSet *)values;

- (void)addDealsObject:(TaloolDealAcquire *)value;
- (void)removeDealsObject:(TaloolDealAcquire *)value;
- (void)addDeals:(NSSet *)values;
- (void)removeDeals:(NSSet *)values;

- (void)addMerchantsObject:(TaloolMerchant *)value;
- (void)removeMerchantsObject:(TaloolMerchant *)value;
- (void)addMerchants:(NSSet *)values;
- (void)removeMerchants:(NSSet *)values;

@end
