//
//  TaloolErrorHandler.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/21/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolErrorHandler.h"
#import "TTransportException.h"
#import "Core.h"
#import "CustomerService.h"
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>
#import "Error.h"

static NSString *defaultMessage = @"We were unable to complete your request.";

@implementation TaloolErrorHandler

- (void) handleServiceException:(NSException *)exception domain:(NSString *)domain method:(NSString *)method error:(NSError **)error
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    NSString *errorDetails;
    ErrorCode code;
    
    if ([exception isKindOfClass:[ServiceException_t class]])
    {
        ServiceException_t *e = (ServiceException_t *)exception;
        errorDetails = [self getErrorMessageWithCode:e.errorCode default:e.errorDesc];
        code = e.errorCode;
    }
    else if ([exception isKindOfClass:[TServiceException_t class]])
    {
        TServiceException_t *e = (TServiceException_t *)exception;
        if (e.messageIsSet)
        {
            errorDetails = e.message;
        }
        else
        {
            errorDetails = [self getErrorMessageWithCode:e.errorCode default:nil];
        }
        
        code = e.errorCode;
    }
    else if ([exception isKindOfClass:[TUserException_t class]])
    {
        TUserException_t *e = (TUserException_t *)exception;
        errorDetails = [self getErrorMessageWithCode:e.errorCode default:nil];
        code = e.errorCode;
    }
    else if ([exception isKindOfClass:[TNotFoundException_t class]])
    {
        TNotFoundException_t *e = (TNotFoundException_t *)exception;
        errorDetails = [NSString stringWithFormat:@"Missing %@ for key %@",e.identifier, e.key];
        NSLog(@"TNotFoundException Handled: %@",errorDetails);
        
        code = ErrorCode_NOT_FOUND_EXCEPTION;
        errorDetails = [self getErrorMessageWithCode:code default:nil];
    }
    else if ([exception isKindOfClass:[TApplicationException class]])
    {
        code = ErrorCode_APP_FAIL;
        errorDetails = [self getErrorMessageWithCode:code default:nil];
    }
    else if ([exception isKindOfClass:[TTransportException class]])
    {
        
        NSError *err = [exception.userInfo objectForKey:@"error"];
        if (err.code == ErrorCode_NETWORK_DOWN)
        {
            code = ErrorCode_NETWORK_DOWN;
            errorDetails = [self getErrorMessageWithCode:code default:nil];
        }
        else
        {
            code = ErrorCode_SERVICE_DOWN;
            errorDetails = [self getErrorMessageWithCode:code default:nil];
        }
    }
    else
    {
        code = ErrorCode_UNKNOWN;
        errorDetails = [self getErrorMessageWithCode:code default:nil];
    }
    
    [details setValue:errorDetails forKey:NSLocalizedDescriptionKey];
    
    *error = [NSError errorWithDomain:domain code:code userInfo:details];
    
    NSLog(@"Exception Handled: %@",errorDetails);
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder
                    createExceptionWithDescription:[NSString stringWithFormat:@"%@: %@: %@: %@",errorDetails, exception.description, domain, method]
                    withFatal:NO] build]];

}

- (void) handleCoreDataException:(NSException *)exception domain:(NSString *)domain method:(NSString *)method entity:(NSString *)entity error:(NSError **)error
{
    ErrorCode code = ErrorCode_CORE_DATA;
    
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    NSString *errorDetails = [self getErrorMessageWithCode:code default:nil];
    [details setValue:errorDetails forKey:NSLocalizedDescriptionKey];
    *error = [NSError errorWithDomain:domain code:code userInfo:details];
    
    NSLog(@"Core Data Exception Handled: %@: %@: %@: %@: %@",errorDetails, exception.description, domain, method, entity);
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder
                    createExceptionWithDescription:[NSString stringWithFormat:@"%@: %@: %@: %@: %@",errorDetails, exception.description, domain, method, entity]
                    withFatal:NO] build]];
    
}

- (void) handlePaymentException:(NSException *)exception domain:(NSString *)domain method:(NSString *)method message:(NSString *)message error:(NSError **)error
{
    [self handleServiceException:exception domain:domain method:method error:error];
}

- (NSString *) getErrorMessageWithCode:(int)code default:(NSString *)defaultMessage
{
    NSString *message;
    
    switch (code) {
        case ErrorCode_VALID_EMAIL_REQUIRED:
            message = @"Please provide a valid email address.";
            break;
        case ErrorCode_PASS_REQUIRED:
            message = @"Your password is required.";
            break;
        case ErrorCode_PASS_CONFIRM_MUST_MATCH:
            message = @"Your passwords must match.";
            break;
        case ErrorCode_PASS_RESET_CODE_REQUIRED:
        case ErrorCode_PASS_RESET_CODE_INVALID:
            message = @"Your password reset request is invalid.";
            break;
        case ErrorCode_PASS_RESET_CODE_EXPIRED:
            message = @"Your password reset request has expired.";
            break;
        case ErrorCode_EMAIL_ALREADY_TAKEN:
            message = @"That email address is already taken.";
            break;
        case ErrorCode_INVALID_USERNAME_OR_PASSWORD:
        case ErrorCode_EMAIL_OR_PASS_INVALID:
            message = @"Your email or password are invalid.";
            break;
        case ErrorCode_CUSTOMER_DOES_NOT_OWN_DEAL:
            message = @"We're sorry, but this deal has been given to another user.";
            break;
        case ErrorCode_DEAL_ALREADY_REDEEMED:
            message = @"This deal has already been redeemed.";
            break;
        case ErrorCode_GIFTING_NOT_ALLOWED:
            message = @"We're sorry, but this deal can not be gifted.";
            break;
        case ErrorCode_CUSTOMER_NOT_FOUND:
            message = @"We couldn't find your account.";
            break;
        case ErrorCode_EMAIL_REQUIRED:
            message = @"Your email is required.";
            break;
        case ErrorCode_GENERAL_PROCESSOR_ERROR:
            message = @"There was a problem processing your payment.  Please try again later.";
            break;
        case ErrorCode_ACTIVIATION_CODE_NOT_FOUND:
            message = @"That activation code was not found.  Please double check your code and try again.";
            break;
        case ErrorCode_ACTIVIATION_CODE_ALREADY_ACTIVATED:
            message = @"That activation code has already been used.  Codes can only be used once.";
            break;
        case ErrorCode_CORE_DATA:
            message = [NSString stringWithFormat:@"%@ %@",defaultMessage, @"Some data could not be saved."];
            break;
        case ErrorCode_NETWORK_DOWN:
            message = [NSString stringWithFormat:@"%@ %@",defaultMessage, @"Your network connection appears to be down."];
            break;
        default:
            if (defaultMessage)
            {
                message = defaultMessage;
            }
            else
            {
                message = [NSString stringWithFormat:@"%@ %@",defaultMessage, @"Please report this error to support@talool.com."];
            }
            break;
    }
    
    return message;
}

@end
