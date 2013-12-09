//
//  ttMerchant.m
//  mobile
//
//  Created by Douglas McCuen on 3/2/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttMerchant.h"
#import "ttMerchantLocation.h"
#import "ttCategory.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"
#import "TaloolFrameworkHelper.h"
#import "MerchantController.h"
#import <APIErrorManager.h>

@interface ttMerchant()
@property (nonatomic, retain) ttMerchantLocation *location;
@end

@implementation ttMerchant

@synthesize location;


#pragma mark -
#pragma mark - Create or Update the Core Data Object

+(ttMerchant *)initWithThrift:(Merchant_t *)merchant context:(NSManagedObjectContext *)context
{
    
    ttMerchant *m = [ttMerchant fetchMerchantById:merchant.merchantId context:context];
    
    m.merchantId = merchant.merchantId;
    m.name = merchant.name;
    m.category = [ttCategory initWithThrift:merchant.category context:context];
    
    
    //NSString *locIsSet = (merchant.locationsIsSet)?@"true":@"false";
    //NSLog(@"DEBUG::: location set: %@ for %@, %d locations",locIsSet,merchant.name, [merchant.locations count]);
    if (merchant.locationsIsSet) {
        m.location = nil;
        @try
        {
            NSMutableArray *locs = [[NSMutableArray alloc] initWithCapacity:[merchant.locations count]];
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
                
                [locs setObject:ml atIndexedSubscript:i];
            }
            m.locations = [NSSet setWithArray:locs];
        }
        @catch (NSException *exception)
        {
            NSLog(@"EXCEPTION::: Failed to load merchant locations for %@", m.name);
        }
        
        @try
        {
            // make sure that location is set
            if (m.location == nil && [m.locations count] > 0)
            {
                m.location = (ttMerchantLocation *)m.locations.objectEnumerator.nextObject;
            }
            else if (m.location == nil)
            {
                NSLog(@"DEBUG::: failed to set location for %@",m.name);
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"EXCEPTION::: Failed to load merchant location for %@", m.name);
        }
        
        if ([m.locations count] < 1)
        {
            NSLog(@"DEBUG::: failed to load locations for %@",m.name);
        }
        else
        {
            //NSLog(@"DEBUG::: loaded location with label %@",[m getLocationLabel]);
        }
    }
    
    return m;
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

+ (NSArray *)fetchMerchants:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    if (predicate)
    {
        [request setPredicate:predicate];
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:MERCHANT_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    return [context executeFetchRequest:request error:&error];
}

#pragma mark -
#pragma mark - Convenience methods for the merchant

- (NSString *)getLocationLabel
{
    NSString *label;
    if ([self.locations count] > 1)
    {
        label = @"multiple locations";
    }
    else if (self.location || [self.locations count] == 1)
    {
        if (self.location == NULL)
        {
            self.location = [[self.locations allObjects] objectAtIndex:0];
        }
        
        if (self.location.name == NULL)
        {
            label = [NSString stringWithFormat:@"%@, %@",self.location.address1, self.location.city];
        }
        else
        {
            label = self.location.name;
        }
    }
    else
    {
        label = @"--";
    }
    return label;
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
    else if ([self.locations count] > 0)
    {
        return [[self.locations allObjects] objectAtIndex:0];
    }
    NSLog(@"DEGUG::: no locations for %@",self.name);
    return nil;
}



#pragma mark -
#pragma mark - Add/Remove Favorites

- (BOOL) favorite:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)error
{
    MerchantController *mc = [[MerchantController alloc] init];
    BOOL result = [mc addFavoriteMerchant:customer merchantId:self.merchantId error:error];
    if (result)
    {
        self.isFav = [NSNumber numberWithBool:YES];
        result = [context save:error];
    }
    return result;
}

- (BOOL) unfavorite:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)error
{
    MerchantController *mc = [[MerchantController alloc] init];
    BOOL result = [mc removeFavoriteMerchant:customer merchantId:self.merchantId error:error];
    if (result)
    {
        self.isFav = [NSNumber numberWithBool:NO];
        result = [context save:error];
    }
    return result;
}




#pragma mark -
#pragma mark - Get the lists of Merchants for a Customer

+ (BOOL) getMerchants:(ttCustomer *)customer
         withLocation:(CLLocation *)loc
              context:(NSManagedObjectContext *)context
                error:(NSError **)error
{
    BOOL result = NO;
    MerchantController *mc = [[MerchantController alloc] init];
    NSMutableArray *merchants = [mc getMerchants:customer withLocation:loc error:error];
    
    if (merchants)
    {
        @try
        {
            // transform the Thrift response and save the context
            for (Merchant_t *m in merchants)
            {
                ttMerchant *tm = [ttMerchant initWithThrift:m context:context];
                tm.customer = customer;
            }
            result = [context save:error];
        }
        @catch (NSException * e)
        {
            [mc.errorManager handleCoreDataException:e forMethod:@"getFavoriteMerchants" entity:@"ttMerchant" error:error];
        }
    }
    
    return result;
}

+ (BOOL) getFavoriteMerchants:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)error
{
    BOOL result = NO;
    MerchantController *mc = [[MerchantController alloc] init];
    NSMutableArray *favs = [mc getFavoriteMerchants:customer error:error];
    
    if (favs)
    {
        @try
        {
            // transform the Thrift response and save the context
            for (Merchant_t *m in favs)
            {
                ttMerchant *tm = [ttMerchant initWithThrift:m context:context];
                tm.isFav = [NSNumber numberWithBool:YES];
            }
            result = [context save:error];
        }
        @catch (NSException * e)
        {
            [mc.errorManager handleCoreDataException:e forMethod:@"getFavoriteMerchants" entity:@"ttMerchant" error:error];
        }
    }
    
    return result;
}




@end
