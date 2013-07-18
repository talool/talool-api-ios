//
//  ttLocation.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/16/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttLocation.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttLocation

+ (ttLocation *)initWithThrift: (Location_t *)location context:(NSManagedObjectContext *)context
{
    ttLocation *m = [ttLocation fetchByLocation:location context:context];
    
    m.latitude = [[NSNumber alloc] initWithDouble:location.latitude];
    m.longitude = [[NSNumber alloc] initWithDouble:location.longitude];
    //NSLog(@"DEBUG::: lat: %f long: %f",location.latitude, location.longitude);
    
    return m;
}

- (Location_t *)hydrateThriftObject
{
    Location_t *location = [[Location_t alloc] init];
    
    location.longitude = [self.longitude doubleValue];
    location.latitude = [self.latitude doubleValue];
    
    return location;
}

+ (ttLocation *) fetchByLocation:(Location_t *)loc_t context:(NSManagedObjectContext *)context
{
    ttLocation *location = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.longitude = %@ AND SELF.latitude = %@",[NSNumber numberWithDouble:loc_t.longitude], [NSNumber numberWithDouble:loc_t.latitude]];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:LOCATION_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    
    if (fetchedObj == nil || [fetchedObj count] == 0)
    {
        location = (ttLocation *)[NSEntityDescription
                                insertNewObjectForEntityForName:LOCATION_ENTITY_NAME
                                inManagedObjectContext:context];
    }
    else
    {
        location = [fetchedObj objectAtIndex:0];
    }
    return location;
}

@end
