//
//  TaloolMerchant.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/15/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolDealOffer, TaloolMerchantLocation, ttCustomer, ttDeal;

@interface TaloolMerchant : NSManagedObject

@property (nonatomic, retain) NSString * merchantId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) ttCustomer *customer;
@property (nonatomic, retain) NSSet *deals;
@property (nonatomic, retain) NSSet *locations;
@property (nonatomic, retain) NSSet *offers;
@end

@interface TaloolMerchant (CoreDataGeneratedAccessors)

- (void)addDealsObject:(ttDeal *)value;
- (void)removeDealsObject:(ttDeal *)value;
- (void)addDeals:(NSSet *)values;
- (void)removeDeals:(NSSet *)values;

- (void)addLocationsObject:(TaloolMerchantLocation *)value;
- (void)removeLocationsObject:(TaloolMerchantLocation *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

- (void)addOffersObject:(TaloolDealOffer *)value;
- (void)removeOffersObject:(TaloolDealOffer *)value;
- (void)addOffers:(NSSet *)values;
- (void)removeOffers:(NSSet *)values;

@end
