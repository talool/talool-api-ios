//
//  MerchantController.m
//  mobile
//
//  Created by Douglas McCuen on 2/18/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "MerchantController.h"

#import "ttCustomer.h"
#import "ttToken.h"
#import "ttMerchant.h"
#import "ttDeal.h"
#import "ttDealAcquire.h"
#import "ttCategory.h"

#import "APIErrorManager.h"

#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

#import "CustomerService.h"
#import "Core.h"
#import "Error.h"


@implementation MerchantController


#pragma mark -
#pragma mark - Get Merchants in a Location

- (NSMutableArray *) getMerchants:(ttCustomer *)customer
                     withLocation:(CLLocation *)location
                            error:(NSError**)error
{
    NSLog(@"GET MERCHANTS WITH LOCATION");
    
    NSMutableArray *merchants;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        Location_t *loc;
        if (location)
        {
            loc = [[Location_t alloc] initWithLongitude:location.coordinate.longitude latitude:location.coordinate.latitude];
        }
        SearchOptions_t *options = [[SearchOptions_t alloc] init];
        [options setMaxResults:1000];
        [options setPage:0];
        [options setAscending:YES];
        [options setSortProperty:@"merchant.name"];
        merchants = [self.service getMerchantAcquiresWithLocation:options location:loc];
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"getMerchantsWithLocation" error:error];
    }
    @finally {
        [self disconnect];
    }
    
    return merchants;
}



#pragma mark -
#pragma mark - Favorites

- (BOOL) addFavoriteMerchant:(ttCustomer *)customer merchantId:(NSString *)merchantId error:(NSError**)error
{
    BOOL result = NO;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        [self.service addFavoriteMerchant:merchantId];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"favorite"
                                                               label:@"success"
                                                               value:nil] build]];
        result = YES;
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"addFavoriteMerchant" error:error];
    }
    @finally {
        [self disconnect];
    }
    
    return result;
}

- (BOOL) removeFavoriteMerchant:(ttCustomer *)customer merchantId:(NSString *)merchantId error:(NSError**)error
{
    BOOL result = NO;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        [self.service removeFavoriteMerchant:merchantId];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"unfavorite"
                                                               label:@"success"
                                                               value:nil] build]];
        result = YES;
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"removeFavoriteMerchant" error:error];
    }
    @finally {
        [self disconnect];
    }
    
    return result;
}

- (NSMutableArray *) getFavoriteMerchants:(ttCustomer *)customer error:(NSError**)error
{
    NSLog(@"GET FAVORITE MERCHANTS");
    
    NSMutableArray *merchants;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        SearchOptions_t *options = [[SearchOptions_t alloc] init];
        [options setMaxResults:1000];
        [options setPage:0];
        [options setAscending:YES];
        [options setSortProperty:@"merchant.name"];
        merchants = [self.service getFavoriteMerchants:options];
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"getFavoriteMerchants" error:error];
    }
    @finally {
        [self disconnect];
    }
    
    return merchants;
}


#pragma mark -
#pragma mark - Categories

- (NSMutableArray *) getCategories:(ttCustomer *)customer error:(NSError**)error
{
    NSMutableArray *categories;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        categories = [self.service getCategories];
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"getCategories" error:error];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    return categories;
}


@end