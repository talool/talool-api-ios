//
//  TaloolPersistentStoreCoordinator.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/9/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolPersistentStoreCoordinator.h"
#import "TaloolFrameworkHelper.h"

NSString * const CUSTOMER_ENTITY_NAME = @"TaloolCustomer";
NSString * const CUSTOMER_UX_ENTITY_NAME = @"TaloolCustomerUX";
NSString * const ADDRESS_ENTITY_NAME = @"TaloolAddress";
NSString * const MERCHANT_ENTITY_NAME = @"TaloolMerchant";
NSString * const MERCHANT_LOCATION_ENTITY_NAME = @"TaloolMerchantLocation";
NSString * const LOCATION_ENTITY_NAME = @"TaloolLocation";
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
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

#warning "The App will crash here if the data model is borked.  Need a more elegant solution."
        abort();
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
