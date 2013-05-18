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
    ttMerchant *m = (ttMerchant *)[NSEntityDescription
                                   insertNewObjectForEntityForName:MERCHANT_ENTITY_NAME
                                   inManagedObjectContext:context];

    m.merchantId = merchant.merchantId;
    m.name = merchant.name;
    m.category = [ttCategory initWithThrift:merchant.category context:context];
    
    if (merchant.locationsIsSet) {
        for (int i=0; i<[merchant.locations count]; i++) {
            MerchantLocation_t *mlt = [merchant.locations objectAtIndex:i];
            ttMerchantLocation *ml = [ttMerchantLocation initWithThrift:mlt context:context];
            
            // TODO this should be the closest location
            if (i==0) {
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

- (ttMerchantLocation *) getClosestLocation:(double)latitude longitude:(double)longitude
{
    NSArray *locs = [[NSArray alloc] initWithArray:[self.locations allObjects]];
    if ([locs count]==0)
    {
        return nil;
    }
    else if ([locs count]==1)
    {
        return [locs objectAtIndex:0];
    }
    else
    {
        // TODO search by location
        //CustomerController *cController = [[CustomerController alloc] init];
        //NSError *error = [NSError alloc];
        
        return [locs objectAtIndex:0];
    }
}


@end
