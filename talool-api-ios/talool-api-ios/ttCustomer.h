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
#import "ttToken.h"
#import "Friend.h"

@class Customer_t, ttMerchant;

@interface ttCustomer : TaloolCustomer

+ (ttCustomer *)initWithThrift: (Customer_t *)customer context:(NSManagedObjectContext *)context;
+ (ttCustomer *)getLoggedInUser:(NSManagedObjectContext *)context;

- (BOOL)isValid:(NSError **)error;
- (Customer_t *)hydrateThriftObject;
- (NSString *)getFullName;
- (ttToken *)getTaloolToken;
- (void) refreshMerchants: (NSManagedObjectContext *)context;
- (NSArray *) getMyMerchants;
- (NSArray *) getMyDealsForMerchant:(ttMerchant *)merchant context:(NSManagedObjectContext *)context;

@end

