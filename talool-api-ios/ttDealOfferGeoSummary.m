//
//  ttDealOfferGeoSummary.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/19/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttDealOfferGeoSummary.h"
#import "DealOfferController.h"
#import "ttDealOffer.h"
#import "ttCustomer.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttDealOfferGeoSummary


#pragma mark -
#pragma mark - Create or Update the Core Data Object

+ (ttDealOfferGeoSummary *)initWithThrift: (DealOfferGeoSummary_t *)geoSummary context:(NSManagedObjectContext *)context
{
    ttDealOfferGeoSummary *summary = [ttDealOfferGeoSummary fetchById:geoSummary.dealOffer.dealOfferId
                                                               context:context];
    
    summary.dealOffer = [ttDealOffer initWithThrift:geoSummary.dealOffer context:context];
    
    if (geoSummary.distanceInMetersIsSet)
    {
        summary.distanceInMeters = [NSNumber numberWithDouble:geoSummary.distanceInMeters];
    }
    else
    {
        summary.distanceInMeters = [NSNumber numberWithInt:9999];
    }
    if (geoSummary.closestMerchantInMetersIsSet)
    {
        summary.closestMerchantInMeters = [NSNumber numberWithDouble:geoSummary.closestMerchantInMeters];
    }
    else
    {
        summary.closestMerchantInMeters = [NSNumber numberWithInt:9999];
    }
    
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


#pragma mark -
#pragma mark - Get the Deal Offer Summaries

+ (BOOL) fetchDealOfferSummaries:(ttCustomer *)customer location:(CLLocation *)location context:(NSManagedObjectContext *)context error:(NSError **)err
{
    BOOL result = NO;
    
    DealOfferController *doc = [[DealOfferController alloc] init];
    NSMutableArray *resultset = [doc getDealOfferGeoSummaries:customer withLocation:location error:err];
    if (resultset)
    {
        // delete all summaries we have, so expired or recently in-active offers go away
        [ttCustomer clearEntity:context entityName:DEAL_OFFER_GEO_SUMMARY_ENTITY_NAME];
        
        // store the objects in the response in CoreData
        for (int i=0; i<[resultset count]; i++) {
            [ttDealOfferGeoSummary initWithThrift:[resultset objectAtIndex:i] context:context];
        }
        
        if ([context save:err]) {
            result = YES;
        }
    }
    
    return result;
}

@end