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
@class ttMerchant;
@class CustomerService_tClient;

@interface CustomerController : NSObject {
    CustomerService_tClient *service;
}

- (ttCustomer *)registerUser:(ttCustomer *)customer password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError**)error;
- (ttCustomer *)authenticate:(NSString *)email password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError**)error;
- (void)save:(ttCustomer *)customer error:(NSError**)error;
- (BOOL)userExists:(NSString *) email;
- (NSMutableArray *) getMerchants:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error;
- (NSMutableArray *) getAcquiredDeals:(ttMerchant *)merchant forCustomer:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error;
- (void) redeem: (NSString *) dealAcquireId latitude: (double) latitude longitude: (double) longitude;

@end