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

@implementation ttMerchant


#pragma mark -
#pragma mark - Create or Update the Core Data Object

+(ttMerchant *)initWithThrift:(Merchant_t *)merchant context:(NSManagedObjectContext *)context
{
    
    ttMerchant *m = [ttMerchant fetchMerchantById:merchant.merchantId context:context];
    
    m.merchantId = merchant.merchantId;
    m.name = merchant.name;
    m.category = [ttCategory initWithThrift:merchant.category context:context];
    
    if (merchant.locationsIsSet)
    {
        // convert the locations
        NSMutableArray *locs = [[NSMutableArray alloc] initWithCapacity:[merchant.locations count]];
        for (int i=0; i<[merchant.locations count]; i++)
        {
            MerchantLocation_t *mlt = [merchant.locations objectAtIndex:i];
            ttMerchantLocation *ml = [ttMerchantLocation initWithThrift:mlt context:context];
            [locs setObject:ml atIndexedSubscript:i];
        }
        
        // sort the locations by distance
        NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                    [NSSortDescriptor sortDescriptorWithKey:@"distanceInMeters" ascending:YES],
                                    nil];
        NSArray *sortedLocations = [locs sortedArrayUsingDescriptors:sortDescriptors];
        
        m.closestLocation = [sortedLocations objectAtIndex:0];
        m.locations = [NSSet setWithArray:sortedLocations];

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
    else if (self.closestLocation || [self.locations count] == 1)
    {
        if (self.closestLocation == NULL)
        {
            self.closestLocation = [[self.locations allObjects] objectAtIndex:0];
        }
        
        if (self.closestLocation.name == NULL)
        {
            label = [NSString stringWithFormat:@"%@, %@",self.closestLocation.address1, self.closestLocation.city];
        }
        else
        {
            label = self.closestLocation.name;
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

- (int) getAvailableDealAcquireCount:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"deal.merchant.merchantId = %@ AND SELF.invalidated = nil",self.merchantId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:DEAL_ACQUIRE_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    NSNumber *n = [NSNumber numberWithLong:[fetchedObj count]];
    return [n intValue];
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
