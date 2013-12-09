//
//  ttMerchant.h
//  mobile
//
//  Created by Douglas McCuen on 3/2/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolMerchant.h"
#import <CoreLocation/CoreLocation.h>

@class Merchant_t, ttCustomer, ttMerchantLocation, ttLocation;

@interface ttMerchant : TaloolMerchant


#pragma mark -
#pragma mark - Create or Update the Core Data Object

+ (ttMerchant *)initWithThrift: (Merchant_t *)merchant context:(NSManagedObjectContext *)context;
+ (ttMerchant *)fetchMerchantById:(NSString *) merchantId context:(NSManagedObjectContext *)context;
+ (NSArray *)fetchMerchants:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate;

#pragma mark -
#pragma mark - Get Merchants

+ (BOOL) getMerchants:(ttCustomer *)customer
         withLocation:(CLLocation *)loc
              context:(NSManagedObjectContext *)context
                error:(NSError **)error;
+ (BOOL) getFavoriteMerchants:(ttCustomer *)customer
                      context:(NSManagedObjectContext *)context
                        error:(NSError **)error;


#pragma mark -
#pragma mark - Add/Remove Favorites

- (BOOL) favorite:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)error;
- (BOOL) unfavorite:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)error;


#pragma mark -
#pragma mark - Convenience

- (ttMerchantLocation *) getClosestLocation;
- (NSString *) getLocationLabel;
- (Boolean) isFavorite;


@end
