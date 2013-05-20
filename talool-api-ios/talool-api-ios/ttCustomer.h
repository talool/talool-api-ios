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

@class Customer_t, ttMerchant;

@interface ttCustomer : TaloolCustomer

@property (nonatomic, retain) NSArray *favoriteMerchants;

+ (ttCustomer *)initWithThrift: (Customer_t *)customer context:(NSManagedObjectContext *)context;
+ (void)clearUsers:(NSManagedObjectContext *)context;
+ (ttCustomer *)getLoggedInUser:(NSManagedObjectContext *)context;
+ (void)logoutUser:(NSManagedObjectContext *)context;
+ (ttCustomer *)authenticate:(NSString *)email password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError **)err;
+ (void) registerCustomer:(ttCustomer *)customer password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError **)err;
+ (void) saveCustomer:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)err;
+ (BOOL) doesCustomerExist:(NSString *) email;
+ (NSString *)nonrandomPassword:(NSString *)seed;
+ (NSString *) randomPassword:(int)length;
+ (ttCustomer *) createCustomer:(NSString *)firstName
                       lastName:(NSString *)lastName
                          email:(NSString *)email
                            sex:(NSNumber *)sex
                  socialAccount:(ttSocialAccount *)socialAccount
                        context:(NSManagedObjectContext *)context;


- (BOOL)isValid:(NSError **)error;
- (Customer_t *)hydrateThriftObject;
- (NSString *)getFullName;
- (ttToken *)getTaloolToken;

- (void) refresh: (NSManagedObjectContext *)context;
- (void) refreshMerchants: (NSManagedObjectContext *)context;
- (void) refreshFavoriteMerchants: (NSManagedObjectContext *)context;

- (NSArray *) refreshMyDealsForMerchant:(ttMerchant *)merchant context:(NSManagedObjectContext *)context error:(NSError **)err purge:(BOOL)purge;
- (NSArray *) getMyMerchants;
- (NSArray *) getMyDealsForMerchant:(ttMerchant *)merchant context:(NSManagedObjectContext *)context error:(NSError **)err;

- (NSArray *) getMerchantsByProximity:(int)distanceInMeters
                            longitude:(double)longitude
                             latitude:(double)latitude
                              context:(NSManagedObjectContext *)context
                                error:(NSError **)err;



@end

