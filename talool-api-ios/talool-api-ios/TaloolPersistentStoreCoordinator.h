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

extern const NSString *CUSTOMER_ENTITY_NAME;
extern const NSString *ADDRESS_ENTITY_NAME;
extern const NSString *MERCHANT_ENTITY_NAME;

+(NSPersistentStoreCoordinator *) initWithStoreUrl:(NSURL *)storeURL;
+(NSManagedObjectModel *) managedObjectModel;

@end
