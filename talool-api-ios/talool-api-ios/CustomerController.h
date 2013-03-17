//
//  CustomerController.h
//  mobile
//
//  Created by Douglas McCuen on 2/21/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ttCustomer;
@class CustomerService_tClient;

@interface CustomerController : NSObject {
    CustomerService_tClient *service;
}

- (void)disconnect;
- (ttCustomer *)registerUser:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error;
- (ttCustomer *)authenticate:(NSString *)email password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError**)error;
- (void)save:(ttCustomer *)customer error:(NSError**)error;
- (ttCustomer *)refreshToken:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error;

@end