//
//  ttMerchantLoction.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/22/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttMerchantLocation.h"
#import "ttAddress.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttMerchantLocation

+(ttMerchantLocation *)initWithThrift:(MerchantLocation_t *)location context:(NSManagedObjectContext *)context
{
    ttMerchantLocation *m = (ttMerchantLocation *)[NSEntityDescription
                                   insertNewObjectForEntityForName:MERCHANT_LOCATION_ENTITY_NAME
                                   inManagedObjectContext:context];
    
    m.locationId = @(location.locationId);
    m.name = location.name;
    m.email = location.email;
    m.websiteUrl = location.websiteUrl;
    m.logUrl = location.logUrl;
    m.phone = location.phone;
    m.address = [ttAddress initWithThrift:location.address context:context];
    
    return m;
}

-(MerchantLocation_t *)hydrateThriftObject
{
    MerchantLocation_t *location = [[MerchantLocation_t alloc] init];
    
    location.locationId = [self.locationId integerValue];
    location.name = self.name;
    location.email = self.email;
    location.websiteUrl = self.websiteUrl;
    location.logUrl = self.logUrl;
    location.phone = self.phone;
    location.address = [(ttAddress *)self.address hydrateThriftObject];
    
    return location;
}

@end
