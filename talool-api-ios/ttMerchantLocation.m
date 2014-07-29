//
//  ttMerchantLoction.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/22/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttMerchantLocation.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"
#import "TaloolFrameworkHelper.h"



@implementation ttMerchantLocation

+(ttMerchantLocation *)initWithThrift:(MerchantLocation_t *)location context:(NSManagedObjectContext *)context
{
    ttMerchantLocation *m = [ttMerchantLocation fetchMerchantLocationById:[NSNumber numberWithLongLong:location.locationId] context:context];
    
    m.locationId = [NSNumber numberWithLongLong:location.locationId];
    m.name = location.name;
    m.email = location.email;
    m.websiteUrl = location.websiteUrl;
    m.logoUrl = location.logoUrl;
    m.imageUrl = location.merchantImageUrl;
    if (!location.merchantImageUrl)
    {
        //NSLog(@"missing image for %@",m.websiteUrl);
    }
    m.phone = location.phone;
    m.address1 = location.address.address1;
    m.address2 = location.address.address2;
    m.city = location.address.city;
    m.stateProvidenceCounty = location.address.stateProvinceCounty;
    m.country = location.address.country;
    m.zip = location.address.zip;
    m.latitude = [NSNumber numberWithDouble:location.location.latitude];
    m.longitude = [NSNumber numberWithDouble:location.location.longitude];
    
    if (location.distanceInMetersIsSet)
    {
        m.distanceInMeters = [[NSNumber alloc] initWithDouble:location.distanceInMeters];
        //NSLog(@"DEBUG::: got distance");
    }
    
    return m;
}

+ (ttMerchantLocation *) fetchMerchantLocationById:(NSNumber *) merchantLocationId context:(NSManagedObjectContext *)context
{
    ttMerchantLocation *merchantLocation = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.locationId = %@",merchantLocationId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:MERCHANT_LOCATION_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    
    if (fetchedObj == nil || [fetchedObj count] == 0)
    {
        merchantLocation = (ttMerchantLocation *)[NSEntityDescription
                                  insertNewObjectForEntityForName:MERCHANT_LOCATION_ENTITY_NAME
                                  inManagedObjectContext:context];
    }
    else
    {
        merchantLocation = [fetchedObj objectAtIndex:0];
    }
    return merchantLocation;
}

- (NSNumber *)getDistanceInMiles
{
    double miles = 0;
    if (self.distanceInMeters != nil)
    {
        miles = [self.distanceInMeters doubleValue]/METERS_PER_MILE;
    }
    return [NSNumber numberWithDouble:miles];
}

@end
