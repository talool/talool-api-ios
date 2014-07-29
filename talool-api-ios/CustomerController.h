//
//  CustomerController.h
//  mobile
//
//  Created by Douglas McCuen on 2/21/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolThriftController.h"

@class Customer_t, ttCustomer, CTokenAccess_t;

@interface CustomerController : TaloolThriftController

- (CTokenAccess_t *)registerUser:(Customer_t *)customer
                    password:(NSString *)password
                       error:(NSError**)error;

- (CTokenAccess_t *)authenticate:(NSString *)email
                    password:(NSString *)password
                       error:(NSError**)error;

- (CTokenAccess_t *)authenticateFacebook:(NSString *)facebookId
                       facebookToken:(NSString *)facebookToken
                               error:(NSError**)error;

- (BOOL)userExists:(NSString *) email;

- (BOOL)sendResetPasswordEmail:(NSString *)email
                         error:(NSError**)error;

- (CTokenAccess_t *)resetPassword:(NSString *)customerId
                   password:(NSString *)password
                       code:(NSString *)resetPasswordCode
                      error:(NSError**)error;

- (NSString *)generateBraintreeClientToken:(ttCustomer *)customer
                                     error:(NSError**)error;

@end