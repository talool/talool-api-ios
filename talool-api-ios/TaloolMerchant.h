//
//  TaloolMerchant.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/17/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolCategory, ttCustomer, ttDeal, ttDealOffer, ttMerchantLocation;

@interface TaloolMerchant : NSManagedObject

@property (nonatomic, retain) NSNumber * isFav;
@property (nonatomic, retain) NSString * merchantId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) ttCustomer *customer;
@property (nonatomic, retain) NSSet *deals;
@property (nonatomic, retain) NSSet *locations;
@property (nonatomic, retain) NSSet *offers;
@property (nonatomic, retain) TaloolCategory *category;
@property (nonatomic, retain) ttMerchantLocation *closestLocation;
@end

@interface TaloolMerchant (CoreDataGeneratedAccessors)

- (void)addDealsObject:(ttDeal *)value;
- (void)removeDealsObject:(ttDeal *)value;
- (void)addDeals:(NSSet *)values;
- (void)removeDeals:(NSSet *)values;

- (void)addLocationsObject:(ttMerchantLocation *)value;
- (void)removeLocationsObject:(ttMerchantLocation *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

- (void)addOffersObject:(ttDealOffer *)value;
- (void)removeOffersObject:(ttDealOffer *)value;
- (void)addOffers:(NSSet *)values;
- (void)removeOffers:(NSSet *)values;

@end
