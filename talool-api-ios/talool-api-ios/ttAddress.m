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
    ttAddress *a = [ttAddress fetchAddressByAddress:address context:context];
    
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

+ (ttAddress *) fetchAddressByAddress:(Address_t *)add_t context:(NSManagedObjectContext *)context
{
    ttAddress *address = nil;

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.address1 = %@ AND SELF.city = %@",add_t.address1, add_t.city];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:ADDRESS_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    
    if (fetchedObj == nil || [fetchedObj count] == 0)
    {
        address = (ttAddress *)[NSEntityDescription
                          insertNewObjectForEntityForName:ADDRESS_ENTITY_NAME
                          inManagedObjectContext:context];
    }
    else
    {
        address = [fetchedObj objectAtIndex:0];
    }
    return address;
}

@end
