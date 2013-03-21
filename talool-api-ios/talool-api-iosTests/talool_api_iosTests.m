//
//  talool_api_iosTests.m
//  talool-api-iosTests
//
//  Created by Douglas McCuen on 3/5/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "talool_api_iosTests.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation talool_api_iosTests

- (void)setUp
{
    NSLog(@"%@ setUp", self.name);
    cController = [[CustomerController alloc] init];
    
    // TODO I don't think I can test the code data code without an App to provide the context.
    // If we need to have unit tests here in the API, I may want to refactor all the core data
    // code out of the API.
    
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"mobile.sqlite"];
    persistentStoreCoordinator = [TaloolPersistentStoreCoordinator initWithStoreUrl:storeURL];
    
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:persistentStoreCoordinator];
    
    STAssertNotNil(cController, @"Cannot create CustomerController instance");
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)tearDown
{
    NSLog(@"%@ tearDown", self.name);
}

- (void)testAuthentication
{
    NSError *err = [NSError alloc];
    ttCustomer *customer = [cController authenticate:@"doug2@talool.com" password:@"abc123" context:context error:&err];
    STAssertNotNil(customer, @"Cannot authenticate customer: %@",err.localizedDescription);
}

@end
