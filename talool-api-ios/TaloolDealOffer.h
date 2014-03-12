//
//  TaloolDealOffer.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/15/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolMerchant, TaloolDealOfferGeoSummary;

@interface TaloolDealOffer : NSManagedObject

@property (nonatomic, retain) NSString * dealOfferId;
@property (nonatomic, retain) NSNumber * dealType;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * iconUrl;
@property (nonatomic, retain) NSString * backgroundUrl;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSDate * expires;
@property (nonatomic, retain) NSNumber * fundraiser;
@property (nonatomic, retain) TaloolMerchant *merchant;
@property (nonatomic, retain) TaloolDealOfferGeoSummary *geoSummary;

@end
