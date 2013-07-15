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
#import "TaloolFrameworkHelper.h"
#import "CustomerController.h"

@interface ttMerchant()
@property (nonatomic, retain) ttMerchantLocation *location;
@end

@implementation ttMerchant

@synthesize location;

+(ttMerchant *)initWithThrift:(Merchant_t *)merchant context:(NSManagedObjectContext *)context
{
    
    ttMerchant *m = [ttMerchant fetchMerchantById:merchant.merchantId context:context];
    
    m.merchantId = merchant.merchantId;
    m.name = merchant.name;
    m.category = [ttCategory initWithThrift:merchant.category context:context];
    
    
    //NSString *locIsSet = (merchant.locationsIsSet)?@"true":@"false";
    //NSLog(@"DEBUG::: location set: %@ for %@",locIsSet,merchant.name);
    
    
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
        
        // make sure that location is set
        if (m.location == nil && [m.locations count] > 0)
        {
            if ([m.locations count] > 0)
            {
                m.location = (ttMerchantLocation *)m.locations.objectEnumerator.nextObject;
            }
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
    if ([self.locations count] > 1)
    {
        label = @"multiple locations";
    }
    else if ([self.locations count] == 1)
    {
        if (location == NULL)
        {
            label = @"";
            //NSLog(@"Holy Shit!!!!! A Merchant w/o a location!!!");
        }
        else if (location.name == NULL)
        {
            label = location.address.city;
        }
        else
        {
            label = location.name;
        }
    }
    else
    {
        label = @"";
        //NSLog(@"Holy Shit!!!!! A Merchant w/o a location!!!");
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

- (ttMerchantLocation *) getClosestLocation
{
    if (location)
    {
        return location;
    }
    else
    {
        return [[self.locations allObjects] objectAtIndex:0];
    }
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

+ (NSArray *) getMerchantsInContext:(NSManagedObjectContext *)context
{
    NSArray *merchants;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //NSPredicate *pred = [NSPredicate predicateWithFormat:@"locations.@count != 0"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"ANY locations.distanceInMeters < %d",DEFAULT_PROXIMITY*METERS_PER_MILE];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:MERCHANT_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    merchants = [context executeFetchRequest:request error:&error];
    
    NSLog(@"DEBUG::: Found %d merchants closer than %d",[merchants count],DEFAULT_PROXIMITY);
    
    return merchants;
}


@end
