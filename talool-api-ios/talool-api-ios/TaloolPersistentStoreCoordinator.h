//
//  TaloolPersistentStoreCoordinator.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/9/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TaloolPersistentStoreCoordinator : NSObject

+(NSPersistentStoreCoordinator *) initWithStoreUrl:(NSURL *)storeURL;
+(NSManagedObjectModel *) managedObjectModel;

@end

extern NSString * const CUSTOMER_ENTITY_NAME;
extern NSString * const ADDRESS_ENTITY_NAME;
extern NSString * const MERCHANT_ENTITY_NAME;
extern NSString * const MERCHANT_LOCATION_ENTITY_NAME;
extern NSString * const LOCATION_ENTITY_NAME;
extern NSString * const SOCIAL_ACCOUNT_ENTITY_NAME;
extern NSString * const SOCIAL_NETWORK_DETAIL_ENTITY_NAME;
extern NSString * const TOKEN_ENTITY_NAME;
extern NSString * const FRIEND_ENTITY_NAME;
extern NSString * const DEAL_ENTITY_NAME;
extern NSString * const DEAL_ACQUIRE_ENTITY_NAME;
extern NSString * const DEAL_OFFER_ENTITY_NAME;
extern NSString * const CATEGORY_ENTITY_NAME;
extern int const SOCIAL_NETWORK_FACEBOOK;
extern int const SOCIAL_NETWORK_TWITTER;
extern int const SOCIAL_NETWORK_PINTEREST;
