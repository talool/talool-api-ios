//
//  ttDealOfferGeoSummary.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/19/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttDealOfferGeoSummary.h"
#import "ttDealOffer.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttDealOfferGeoSummary

+ (ttDealOfferGeoSummary *)initWithThrift: (DealOfferGeoSummary_t *)geoSummary context:(NSManagedObjectContext *)context
{
    ttDealOfferGeoSummary *summary = [ttDealOfferGeoSummary fetchById:geoSummary.dealOffer.dealOfferId
                                                               context:context];
    
    summary.dealOffer = [ttDealOffer initWithThrift:geoSummary.dealOffer context:context];
    
    summary.distanceInMeters = [NSNumber numberWithDouble:geoSummary.distanceInMeters];
    summary.closestMerchantInMeters = [NSNumber numberWithDouble:geoSummary.closestMerchantInMeters];
    
    summary.totalDeals = [geoSummary.longMetrics objectForKey:[CoreConstants METRIC_TOTAL_DEALS]];
    summary.totalMerchants = [geoSummary.longMetrics objectForKey:[CoreConstants METRIC_TOTAL_MERCHANTS]];
    summary.totalAcquires = [geoSummary.longMetrics objectForKey:[CoreConstants METRIC_TOTAL_ACQUIRES]];
    summary.totalRedemptions = [geoSummary.longMetrics objectForKey:[CoreConstants METRIC_TOTAL_REDEMPTIONS]];
    
    
    return summary;
}

+ (ttDealOfferGeoSummary *) fetchById:(NSString *) entityId context:(NSManagedObjectContext *)context
{
    ttDealOfferGeoSummary *summary = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"dealOffer.dealOfferId = %@",entityId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:DEAL_OFFER_GEO_SUMMARY_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    
    if (fetchedObj == nil || [fetchedObj count] == 0)
    {
        summary = (ttDealOfferGeoSummary *)[NSEntityDescription
                                          insertNewObjectForEntityForName:DEAL_OFFER_GEO_SUMMARY_ENTITY_NAME
                                          inManagedObjectContext:context];
    }
    else
    {
        summary = [fetchedObj objectAtIndex:0];
    }
    return summary;
}

@end