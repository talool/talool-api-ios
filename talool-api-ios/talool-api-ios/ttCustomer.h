//
//  ttCustomer.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/13/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TaloolCustomer.h"

@class Customer_t;

@interface ttCustomer : TaloolCustomer

@property (nonatomic, retain) Customer_t * thrift;

- (BOOL)isValid:(NSError **)error;
+ (ttCustomer *)initWithThrift: (Customer_t *)customer;
- (Customer_t *)hydrateThriftObject;
- (NSString *)getFullName;

@end
