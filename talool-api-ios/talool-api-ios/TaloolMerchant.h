//
//  TaloolMerchant.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/22/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolCustomer, TaloolDeal, TaloolDealAcquire, TaloolMerchantLocation;

@interface TaloolMerchant : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * merchantId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSSet *locations;
@property (nonatomic, retain) NSSet *deals;
@property (nonatomic, retain) NSSet *shares;
@property (nonatomic, retain) TaloolCustomer *customers;
@end

@interface TaloolMerchant (CoreDataGeneratedAccessors)

- (void)addLocationsObject:(TaloolMerchantLocation *)value;
- (void)removeLocationsObject:(TaloolMerchantLocation *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

- (void)addDealsObject:(TaloolDeal *)value;
- (void)removeDealsObject:(TaloolDeal *)value;
- (void)addDeals:(NSSet *)values;
- (void)removeDeals:(NSSet *)values;

- (void)addSharesObject:(TaloolDealAcquire *)value;
- (void)removeSharesObject:(TaloolDealAcquire *)value;
- (void)addShares:(NSSet *)values;
- (void)removeShares:(NSSet *)values;

@end
