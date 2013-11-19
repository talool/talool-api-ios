//
//  TaloolDealOfferGeoSummary.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/19/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolDealOffer;

@interface TaloolDealOfferGeoSummary : NSManagedObject

@property (nonatomic, retain) NSNumber * distanceInMeters;
@property (nonatomic, retain) NSNumber * closestMerchantInMeters;
@property (nonatomic, retain) NSNumber * totalMerchants;
@property (nonatomic, retain) NSNumber * totalRedemptions;
@property (nonatomic, retain) NSNumber * totalDeals;
@property (nonatomic, retain) NSNumber * totalAcquires;
@property (nonatomic, retain) TaloolDealOffer *dealOffer;

@end
