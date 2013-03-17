//
//  ttAddress.m
//  mobile
//
//  Created by Douglas McCuen on 3/2/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttAddress.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttAddress

-(BOOL)isValid
{
    return TRUE;
}

+(ttAddress *)initWithThrift:(Address_t *)address context:(NSManagedObjectContext *)context
{
    ttAddress *a = (ttAddress *)[NSEntityDescription
                                  insertNewObjectForEntityForName:ADDRESS_ENTITY_NAME
                                  inManagedObjectContext:context];
    a.address1 = address.address1;
    a.address2 = address.address2;
    a.city = address.city;
    a.country = address.country;
    a.stateProvidenceCounty = address.stateProvinceCounty;
    a.zip = address.zip;
    return a;
}

-(Address_t *)hydrateThriftObject
{
    Address_t *address = [[Address_t alloc] init];
    address.address1 = self.address1;
    address.address2 = self.address2;
    address.city = self.city;
    address.country = self.country;
    address.stateProvinceCounty = self.stateProvidenceCounty;
    address.zip = self.zip;
    
    return address;
}

@end
