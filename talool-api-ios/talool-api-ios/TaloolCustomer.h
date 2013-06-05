//
//  TaloolCustomer.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/4/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SocialAccount, TaloolDealAcquire, TaloolGift, ttMerchant, ttToken;

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
@property (nonatomic, retain) ttToken *token;
@property (nonatomic, retain) NSSet *sharedDealAcquires;
@property (nonatomic, retain) NSSet *gifts;
@end

@interface TaloolCustomer (CoreDataGeneratedAccessors)

- (void)addMerchantsObject:(ttMerchant *)value;
- (void)removeMerchantsObject:(ttMerchant *)value;
- (void)addMerchants:(NSSet *)values;
- (void)removeMerchants:(NSSet *)values;

- (void)addSocialAccountsObject:(SocialAccount *)value;
- (void)removeSocialAccountsObject:(SocialAccount *)value;
- (void)addSocialAccounts:(NSSet *)values;
- (void)removeSocialAccounts:(NSSet *)values;

- (void)addSharedDealAcquiresObject:(TaloolDealAcquire *)value;
- (void)removeSharedDealAcquiresObject:(TaloolDealAcquire *)value;
- (void)addSharedDealAcquires:(NSSet *)values;
- (void)removeSharedDealAcquires:(NSSet *)values;

- (void)addGiftsObject:(TaloolGift *)value;
- (void)removeGiftsObject:(TaloolGift *)value;
- (void)addGifts:(NSSet *)values;
- (void)removeGifts:(NSSet *)values;

@end
