//
//  ttDealOfferGeoSummary.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/19/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolDealOfferGeoSummary.h"

@class DealOfferGeoSummary_t;

@interface ttDealOfferGeoSummary : TaloolDealOfferGeoSummary

+ (ttDealOfferGeoSummary *)initWithThrift: (DealOfferGeoSummary_t *)geoSummary context:(NSManagedObjectContext *)context;

@end
