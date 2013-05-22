//
//  ttMerchant.m
//  mobile
//
//  Created by Douglas McCuen on 3/2/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttMerchant.h"
#import "ttMerchantLocation.h"
#import "ttAddress.h"
#import "ttCategory.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"
#import "CustomerController.h"

@implementation ttMerchant

@synthesize location;

+(ttMerchant *)initWithThrift:(Merchant_t *)merchant context:(NSManagedObjectContext *)context
{
    
    ttMerchant *m = [ttMerchant fetchMerchantById:merchant.merchantId context:context];
    
    m.merchantId = merchant.merchantId;
    m.name = merchant.name;
    m.category = [ttCategory initWithThrift:merchant.category context:context];
    
    if (merchant.locationsIsSet) {
        
        
        if ([m.locations count]>0)
        {
            [m removeLocations:m.locations];
        }
        
        int closestDistance = 100000000;
        for (int i=0; i<[merchant.locations count]; i++) {
            MerchantLocation_t *mlt = [merchant.locations objectAtIndex:i];
            ttMerchantLocation *ml = [ttMerchantLocation initWithThrift:mlt context:context];
            
            // store the closest location for easy access
            if (mlt.distanceInMetersIsSet && mlt.distanceInMeters<closestDistance)
            {
                closestDistance = mlt.distanceInMeters;
                m.location = ml;
            }
            
            [m addLocationsObject:ml];
        }
    }
    
    return m;
}

-(Merchant_t *)hydrateThriftObject
{
    Merchant_t *merchant = [[Merchant_t alloc] init];
    
    merchant.merchantId = self.merchantId;
    merchant.name = self.name;
    merchant.category = [(ttCategory *)self.category hydrateThriftObject];
    
    NSEnumerator *enumerator = [self.locations objectEnumerator];
    ttMerchantLocation *ml;
    MerchantLocation_t *mlt;
    int i=0;
    while (ml = [enumerator nextObject]) {
        mlt = [ml hydrateThriftObject];
        [merchant.locations setObject:mlt atIndexedSubscript:i++];
    }

    return merchant;
}

- (NSString *)getLocationLabel
{
    NSString *label;
    if ([self.locations count] > 1) {
        label = @"multiple locations";
    } else {
        if (location.name == NULL) {
            label = location.address.city;
        } else {
            label = location.name;
        }
    }
    return label;
}

- (void) favorite:(ttCustomer *)customer
{
    CustomerController *cController = [[CustomerController alloc] init];
    NSError *error = [NSError alloc];
    [cController addFavoriteMerchant:customer merchantId:self.merchantId error:&error];
    self.isFav = [NSNumber numberWithBool:YES];
}

- (void) unfavorite:(ttCustomer *)customer
{
    CustomerController *cController = [[CustomerController alloc] init];
    NSError *error = [NSError alloc];
    [cController removeFavoriteMerchant:customer merchantId:self.merchantId error:&error];
    self.isFav = [NSNumber numberWithBool:NO];
}

- (Boolean) isFavorite
{
    return [self.isFav boolValue];
}

/*
 *  TODO We can remove this since it's handled during the init
 */
- (ttMerchantLocation *) getClosestLocation:(double)latitude longitude:(double)longitude
{
    return location;
}
                                    
+ (ttMerchant *) fetchMerchantById:(NSString *) merchantId context:(NSManagedObjectContext *)context
{
    ttMerchant *merchant = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.merchantId = %@",merchantId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:MERCHANT_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    
    if (fetchedObj == nil || [fetchedObj count] == 0)
    {
        merchant = (ttMerchant *)[NSEntityDescription
                       insertNewObjectForEntityForName:MERCHANT_ENTITY_NAME
                       inManagedObjectContext:context];
    }
    else
    {
        merchant = [fetchedObj objectAtIndex:0];
    }
    return merchant;
}


@end
