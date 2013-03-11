//
//  TaloolPersistentStoreCoordinator.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/9/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolPersistentStoreCoordinator.h"
#import "TaloolFrameworkHelper.h"


@implementation TaloolPersistentStoreCoordinator

const NSString *CUSTOMER_ENTITY_NAME = @"TaloolCustomer";
const NSString *ADDRESS_ENTITY_NAME = @"TaloolAddress";
const NSString *MERCHANT_ENTITY_NAME = @"TaloolMerchant";

static NSManagedObjectModel *_managedObjectModel;

+ (NSPersistentStoreCoordinator *) initWithStoreUrl:(NSURL *)storeURL
{
    NSError *error = nil;
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
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
    
    NSURL *modelURL = [[TaloolFrameworkHelper frameworkBundle] URLForResource:@"Talool" withExtension:@"mom"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

@end
