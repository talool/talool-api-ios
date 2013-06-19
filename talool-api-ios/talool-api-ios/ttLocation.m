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
    ttLocation *m = (ttLocation *)[NSEntityDescription
                                                   insertNewObjectForEntityForName:LOCATION_ENTITY_NAME
                                                   inManagedObjectContext:context];
    
    m.latitude = [[NSNumber alloc] initWithDouble:location.latitude];
    m.longitude = [[NSNumber alloc] initWithDouble:location.longitude];
    //NSLog(@"lat: %f long: %f",location.latitude, location.longitude);
    
    return m;
}

- (Location_t *)hydrateThriftObject
{
    Location_t *location = [[Location_t alloc] init];
    
    location.longitude = [self.longitude doubleValue];
    location.latitude = [self.latitude doubleValue];
    
    return location;
}

@end
