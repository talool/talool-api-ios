//
//  talool_api_iosTests.h
//  talool-api-iosTests
//
//  Created by Douglas McCuen on 3/5/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "CustomerController.h"

@interface talool_api_iosTests : SenTestCase{
@private
    CustomerController *cController;
    NSManagedObjectContext *context;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@end
