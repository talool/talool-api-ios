//
//  ttMerchantLoction.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/22/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttMerchantLocation.h"
#import "ttAddress.h"
#import "ttLocation.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"

#define METERS_PER_MILE 1609.344

@implementation ttMerchantLocation

+(ttMerchantLocation *)initWithThrift:(MerchantLocation_t *)location context:(NSManagedObjectContext *)context
{
    ttMerchantLocation *m = [ttMerchantLocation fetchMerchantLocationById:[NSNumber numberWithInt:location.locationId] context:context];
    
    m.locationId = @(location.locationId);
    m.name = location.name;
    m.email = location.email;
    m.websiteUrl = location.websiteUrl;
    m.logoUrl = location.logoUrl;
    m.imageUrl = location.merchantImageUrl;
    m.phone = location.phone;
    m.location = [ttLocation initWithThrift:location.location context:context];
    m.address = [ttAddress initWithThrift:location.address context:context];
    if (location.distanceInMetersIsSet)
    {
        m.distanceInMeters = [[NSNumber alloc] initWithDouble:location.distanceInMeters];
    }
    
    return m;
}

-(MerchantLocation_t *)hydrateThriftObject
{
    MerchantLocation_t *location = [[MerchantLocation_t alloc] init];
    
    location.locationId = [self.locationId integerValue];
    location.name = self.name;
    location.email = self.email;
    location.websiteUrl = self.websiteUrl;
    location.logoUrl = self.logoUrl;
    location.merchantImageUrl = self.imageUrl;
    location.phone = self.phone;
    location.address = [(ttAddress *)self.address hydrateThriftObject];
    location.location = [(ttLocation *)self.location hydrateThriftObject];
    location.distanceInMeters = [self.distanceInMeters doubleValue];
    
    return location;
}

+ (ttMerchantLocation *) fetchMerchantLocationById:(NSNumber *) merchantLocationId context:(NSManagedObjectContext *)context
{
    ttMerchantLocation *merchantLocation = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"locationId = %@",merchantLocationId];
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
