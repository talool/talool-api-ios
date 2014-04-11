//
//  TaloolPersistentStoreCoordinator.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/9/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolPersistentStoreCoordinator.h"
#import "TaloolFrameworkHelper.h"
#import "APIErrorManager.h"
#import "TestFlight.h"
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

NSString * const CUSTOMER_ENTITY_NAME = @"TaloolCustomer";
NSString * const CUSTOMER_UX_ENTITY_NAME = @"TaloolCustomerUX";
NSString * const MERCHANT_ENTITY_NAME = @"TaloolMerchant";
NSString * const MERCHANT_LOCATION_ENTITY_NAME = @"TaloolMerchantLocation";
NSString * const SOCIAL_ACCOUNT_ENTITY_NAME = @"SocialAccount";
NSString * const SOCIAL_NETWORK_DETAIL_ENTITY_NAME = @"SocialNetworkDetail";
NSString * const TOKEN_ENTITY_NAME = @"TaloolToken";
NSString * const DEAL_ENTITY_NAME = @"TaloolDeal";
NSString * const GIFT_ENTITY_NAME = @"TaloolGift";
NSString * const DEAL_ACQUIRE_ENTITY_NAME = @"TaloolDealAcquire";
NSString * const DEAL_OFFER_ENTITY_NAME = @"TaloolDealOffer";
NSString * const FRIEND_ENTITY_NAME = @"Friend";
NSString * const CATEGORY_ENTITY_NAME = @"TaloolCategory";
NSString * const ACTIVITY_ENTITY_NAME = @"TaloolActivity";
NSString * const ACTIVITY_LINK_ENTITY_NAME = @"TaloolActivityLink";
NSString * const DEAL_OFFER_GEO_SUMMARY_ENTITY_NAME = @"TaloolDealOfferGeoSummary";
NSString * const GIFT_DETAIL_ENTITY_NAME = @"TaloolGiftDetail";
int const SOCIAL_NETWORK_FACEBOOK = 1;
int const SOCIAL_NETWORK_TWITTER = 2;
int const SOCIAL_NETWORK_PINTEREST = 3;

@implementation TaloolPersistentStoreCoordinator

static NSManagedObjectModel *_managedObjectModel;

+ (NSPersistentStoreCoordinator *) initWithStoreUrl:(NSURL *)storeURL
{
    NSError *error = nil;
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *optionsDictionary =
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
            [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
         nil];
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:storeURL
                                                        options:optionsDictionary
                                                          error:&error]) {
        
        // Track failure
        [TestFlight passCheckpoint:@"PERSISTENCE_STORE_BORKED"];
        NSLog(@"PERSISTENCE ERROR: %@, %@", error, [error userInfo]);
        NSException *e = [[NSException alloc] initWithName:@"Persistent Store Failure" reason:@"Failed to init store" userInfo:nil];
        APIErrorManager *errorMgr = [[APIErrorManager alloc] init];
        [errorMgr handleCoreDataException:e forMethod:@"initWithStoreUrl" entity:@"NSPersistentStoreCoordinator" error:&error];
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"APP"
                                                              action:@"coredata"
                                                               label:@"fail"
                                                               value:nil] build]];
        
        // TODO consider clearing all the data
        if (![[TaloolFrameworkHelper sharedInstance] isProduction])
        {
            // In dev we want to see it crash
            abort();
        }

    }
    return persistentStoreCoordinator;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
+ (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[TaloolFrameworkHelper frameworkBundle] URLForResource:@"Talool" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

@end
