//
//  CustomerController.m
//  mobile
//
//  Created by Douglas McCuen on 2/21/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "CustomerController.h"
#import "APIErrorManager.h"

#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

#import "CustomerService.h"
#import "Core.h"
#import "Error.h"

#import "ttCustomer.h"
#import "ttToken.h"


@implementation CustomerController

- (CTokenAccess_t *)registerUser:(Customer_t *)customer password:(NSString *)password error:(NSError**)error
{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    CTokenAccess_t *token;
    
    @try {
        // Do the Thrift Registration
        [self connect];
        token = [self.service createAccount:customer password:password];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"registerUser"
                                                               label:@"success"
                                                               value:nil] build]];
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"registerUser" error:error];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"registerUser"
                                                               label:@"fail:service_exception"
                                                               value:nil] build]];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    return token;
    
}

- (CTokenAccess_t *)authenticate:(NSString *)email password:(NSString *)password error:(NSError**)error;
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    CTokenAccess_t *token;
    
    @try {
        // Do the Thrift Authentication
        [self connect];
        token = [self.service authenticate:email password:password];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"authenticate"
                                                               label:@"success"
                                                               value:nil] build]];
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"authenticate" error:error];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"authenticate"
                                                               label:@"fail:service_exception"
                                                               value:nil] build]];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    return token;
}

- (CTokenAccess_t *)authenticateFacebook:(NSString *)facebookId
                       facebookToken:(NSString *)facebookToken
                               error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    CTokenAccess_t *token;
    CTokenAccessResponse_t *resp;
    
    @try {
        // Do the Thrift Authentication
        [self connect];
        resp = [self.service loginFacebook:facebookId facebookAccessToken:facebookToken];
        if (resp.tokenAccessIsSet)
        {
            token = resp.tokenAccess;
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                                  action:@"authenticate"
                                                                   label:@"success"
                                                                   value:nil] build]];
        }
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"authenticateFacebook" error:error];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"authenticateFacebook"
                                                               label:@"fail:service_exception"
                                                               value:nil] build]];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    return token;
}

- (BOOL)userExists:(NSString *) email
{
    
    BOOL userExists = NO;
    @try {
        [self connect];
        userExists = [self.service customerEmailExists:email];
    }
    @catch (ServiceException_t * se) {
        NSLog(@"failed to search email: %@",se.description);
    }
    @catch (NSException * e) {
        NSLog(@"failed to search email: %@",e.description);
    }
    @finally {
        [self disconnect];
    }
    return userExists;
}

- (BOOL)sendResetPasswordEmail:(NSString *)email error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    BOOL result = NO;
    
    @try {
        [self connect];
        [self.service sendResetPasswordEmail:email];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"sendResetPasswordEmail"
                                                               label:@"success"
                                                               value:nil] build]];
        result = YES;
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"sendResetPasswordEmail" error:error];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"sendResetPasswordEmail"
                                                               label:@"fail"
                                                               value:nil] build]];
    }
    @finally {
        [self disconnect];
    }
    return result;
}

- (CTokenAccess_t *)resetPassword:(NSString *)customerId
                   password:(NSString *)password
                       code:(NSString *)resetPasswordCode
                      error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    CTokenAccess_t *token;
    
    @try {
        [self connect];
        token = [self.service resetPassword:customerId resetPasswordCode:resetPasswordCode newPassword:password];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"resetPassword"
                                                               label:@"success"
                                                               value:nil] build]];
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"resetPassword" error:error];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"resetPassword"
                                                               label:@"fail"
                                                               value:nil] build]];
    }
    @finally {
        [self disconnect];
    }

    
    return token;
}

- (NSString *)generateBraintreeClientToken:(ttCustomer *)customer
                                     error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSString *token;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        
        token = [self.service generateBraintreeClientToken];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"generateBraintreeClientToken"
                                                               label:@"success"
                                                               value:nil] build]];
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"generateBraintreeClientToken" error:error];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"generateBraintreeClientToken"
                                                               label:@"fail"
                                                               value:nil] build]];
    }
    @finally {
        [self disconnect];
    }
    
    
    return token;
    
}



@end
