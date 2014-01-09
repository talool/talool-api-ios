//
//  ttCustomer.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/13/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "TaloolCustomer.h"
#import "ttToken.h"

@class Customer_t, ttMerchant, ttSocialAccount, ttDealAcquire, ttDealOffer;

@interface ttCustomer : TaloolCustomer

+ (ttCustomer *)initWithThrift: (Customer_t *)customer context:(NSManagedObjectContext *)context;


#pragma mark -
#pragma mark Login/Logout (static methods)

+ (BOOL) clearUsers:(NSManagedObjectContext *)context error:(NSError**)error;

+ (BOOL) logoutUser:(NSManagedObjectContext *)context error:(NSError**)error;

+ (BOOL) authenticate:(NSString *)email
             password:(NSString *)password
              context:(NSManagedObjectContext *)context
                error:(NSError **)err;

+ (BOOL) authenticateFacebook:(NSString *)facebookId
                       facebookToken:(NSString *)facebookToken
                             context:(NSManagedObjectContext *)context
                               error:(NSError**)error;

+ (BOOL) registerCustomer:(ttCustomer *)customer
                 password:(NSString *)password
                  context:(NSManagedObjectContext *)context
                    error:(NSError **)err;



+ (BOOL) sendResetPasswordEmail:(NSString *)email
                         error:(NSError**)error;

+ (BOOL) resetPassword:(NSString *)customerId
                     password:(NSString *)password
                         code:(NSString *)resetPasswordCode
                      context:(NSManagedObjectContext *)context
                        error:(NSError**)error;

+ (BOOL) doesCustomerExist:(NSString *) email;


#pragma mark -
#pragma mark Convenience Methods

- (BOOL)isValid:(NSError **)error password:(NSString *)password;
- (BOOL)isFacebookUser;
- (NSString *)getFullName;
- (void)setAsFemale:(BOOL)isFemale;
- (Customer_t *)hydrateThriftObject;
+ (NSString *)nonrandomPassword:(NSString *)seed;
+ (NSString *) randomPassword:(int)length;
+ (ttCustomer *)getLoggedInUser:(NSManagedObjectContext *)context;
+ (ttCustomer *) createCustomer:(NSString *)firstName
                       lastName:(NSString *)lastName
                          email:(NSString *)email
                  socialAccount:(ttSocialAccount *)socialAccount
                        context:(NSManagedObjectContext *)context;



@end

