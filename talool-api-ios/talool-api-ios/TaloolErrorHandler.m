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
#import "GAI.h"
#import "Error.h"

static NSString *errorFormat = @"Failed %@.  Reason: %@";

@implementation TaloolErrorHandler

- (void) handleServiceException:(NSException *)exception domain:(NSString *)domain method:(NSString *)method error:(NSError **)error
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    NSString *errorDetails;
    TaloolErrorCodeType code;
    
    if ([exception isKindOfClass:[ServiceException_t class]])
    {
        ServiceException_t *e = (ServiceException_t *)exception;
        errorDetails = [self getErrorMessageWithCode:e.errorCode];
        code = e.errorCode;
    }
    else if ([exception isKindOfClass:[TUserException_t class]])
    {
        TUserException_t *e = (TUserException_t *)exception;
        errorDetails = [self getErrorMessageWithCode:e.errorCode];
        code = e.errorCode;
    }
    else if ([exception isKindOfClass:[TNotFoundException_t class]])
    {
        TNotFoundException_t *e = (TNotFoundException_t *)exception;
        errorDetails = [self getServiceDetails:method why:[NSString stringWithFormat:@"Missing %@ for key %@",e.identifier, e.key]];
        code = ERROR_CODE_NOT_FOUND_EXCEPTION;
    }
    else if ([exception isKindOfClass:[TException class]])
    {
        errorDetails = [self getServiceDetails:method why:exception.description];
        code = ERROR_CODE_DEFAULT;
    }
    else if ([exception isKindOfClass:[TApplicationException class]])
    {
        errorDetails = [self getServiceDetails:method why:@"The App Failed"];
        code = ERROR_CODE_APP_FAIL;
    }
    else if ([exception isKindOfClass:[TTransportException class]])
    {
        
        NSError *err = [exception.userInfo objectForKey:@"error"];
        if (err.code == ERROR_CODE_NETWORK_DOWN)
        {
            errorDetails = [self getServiceDetails:method why:err.localizedDescription];
            code = ERROR_CODE_NETWORK_DOWN;
        }
        else
        {
            errorDetails = [self getServiceDetails:method why:@"The Server Barfed"];
            code = ERROR_CODE_TOMCAT_DOWN;
        }
    }
    else
    {
        errorDetails = [self getServiceDetails:method why:@"... who knows why ..."];
        code = ERROR_CODE_DEFAULT;
    }
    
    [details setValue:errorDetails forKey:NSLocalizedDescriptionKey];
    
    *error = [NSError errorWithDomain:domain code:code userInfo:details];
    
    NSLog(@"Exception Handled: %@",errorDetails);
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    //[tracker sendException:NO withNSException:exception];
    [tracker sendException:NO withDescription:@"%@: %@",errorDetails, exception.description];
}

- (void) handleCoreDataException:(NSException *)exception domain:(NSString *)domain method:(NSString *)method entity:(NSString *)entity error:(NSError **)error
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    NSString *errorDetails = [self getCoreDataDetails:method where:entity];
    
    TaloolErrorCodeType code = ERROR_CODE_CORE_DATA;
    
    [details setValue:errorDetails forKey:NSLocalizedDescriptionKey];
    *error = [NSError errorWithDomain:domain code:code userInfo:details];
    
    NSLog(@"%@: %@",errorDetails, exception.description);
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    //[tracker sendException:NO withNSException:exception];
    [tracker sendException:NO withDescription:@"%@: %@",errorDetails, exception.description];
    
}

- (void) handlePaymentException:(NSException *)exception domain:(NSString *)domain method:(NSString *)method message:(NSString *)message error:(NSError **)error
{
    [self handleServiceException:exception domain:domain method:method error:error];
}

- (NSString *) getServiceDetails:(NSString *)what why:(NSString *) why
{
    return [NSString stringWithFormat:errorFormat, what, why];
}

- (NSString *) getErrorMessageWithCode:(int)code
{
    NSString *message;
    
    switch (code) {
        case ErrorCode_t_VALID_EMAIL_REQUIRED:
            message = @"Please provide a valid email address.";
            break;
        case ErrorCode_t_PASS_REQUIRED:
            message = @"Your password is required.";
            break;
        case ErrorCode_t_PASS_CONFIRM_MUST_MATCH:
            message = @"Your passwords must match.";
            break;
        case ErrorCode_t_PASS_RESET_CODE_REQUIRED:
        case ErrorCode_t_PASS_RESET_CODE_INVALID:
            message = @"Your password reset request is invalid.";
            break;
        case ErrorCode_t_PASS_RESET_CODE_EXPIRED:
            message = @"Your password reset request has expired.";
            break;
        case ErrorCode_t_EMAIL_ALREADY_TAKEN:
            message = @"That email address is already taken.";
            break;
        case ErrorCode_t_INVALID_USERNAME_OR_PASSWORD:
        case ErrorCode_t_EMAIL_OR_PASS_INVALID:
            message = @"Your email or password are invalid.";
            break;
        case ErrorCode_t_CUSTOMER_DOES_NOT_OWN_DEAL:
            message = @"We're sorry, but this deal has been given to another user.";
            break;
        case ErrorCode_t_DEAL_ALREADY_REDEEMED:
            message = @"This deal has already been redeemed.";
            break;
        case ErrorCode_t_GIFTING_NOT_ALLOWED:
            message = @"We're sorry, but this deal can not be gifted.";
            break;
        case ErrorCode_t_CUSTOMER_NOT_FOUND:
            message = @"We couldn't find your account.";
            break;
        case ErrorCode_t_EMAIL_REQUIRED:
            message = @"You're email is required.";
            break;
        case ErrorCode_t_GENERAL_PROCESSOR_ERROR:
            message = @"There was a problem processing your payment.  Please try again later.";
            break;
        case ErrorCode_t_ACTIVIATION_CODE_NOT_FOUND:
            message = @"That activation code was not found.  Please double check your code and try again.";
            break;
        case ErrorCode_t_ACTIVIATION_CODE_ALREADY_ACTIVATED:
            message = @"That activation code has already been used.  Codes can only be used once.";
            break;
        default:
            message = @"We could not process your request at this time.  Please try again later.";
            NSLog(@"Unknown error: %d", code);
            break;
    }
    
    return message;
}

- (NSString *) getCoreDataDetails:(NSString *)what where:(NSString *)where
{
    return [NSString stringWithFormat:errorFormat, what, where];
}

- (NSString *) getPaymentDetails:(NSString *)what why:(NSString *)why
{
    return [NSString stringWithFormat:errorFormat, what, why];
}

@end
