//
//  ttDealOfferGeoSummary.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/19/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolDealOfferGeoSummary.h"
#import <CoreLocation/CoreLocation.h>

@class DealOfferGeoSummary_t, ttCustomer;

@interface ttDealOfferGeoSummary : TaloolDealOfferGeoSummary

+ (ttDealOfferGeoSummary *)initWithThrift: (DealOfferGeoSummary_t *)geoSummary context:(NSManagedObjectContext *)context;
+ (BOOL) fetchDealOfferSummaries:(ttCustomer *)customer location:(CLLocation *)location context:(NSManagedObjectContext *)context error:(NSError **)err;

@end
