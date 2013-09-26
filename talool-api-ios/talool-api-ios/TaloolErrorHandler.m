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
        if (e.errorCode == ERROR_CODE_INVALID_PASSWORD)
        {
            errorDetails = e.errorDesc;
            code = ERROR_CODE_INVALID_PASSWORD;
        }
        else if (e.errorCode == ERROR_CODE_INVALID_EMAIL)
        {
            errorDetails = e.errorDesc;
            code = ERROR_CODE_INVALID_PASSWORD;
        }
        else if (e.errorCode == ERROR_CODE_EMAIL_TAKEN)
        {
            errorDetails = e.errorDesc;
            code = ERROR_CODE_INVALID_PASSWORD;
        }
        else
        {
            errorDetails = [self getServiceDetails:method why:@"The Service Failed"];
            code = ERROR_CODE_SERVICE_DOWN;
            NSLog(@"%@: %@",errorDetails, exception.description);
        }
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
    if (exception) {
        message = exception.description;
    }
    
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    NSString *errorDetails = [self getPaymentDetails:method why:message];
    
    TaloolErrorCodeType code = ERROR_CODE_PAYMENT;
    
    [details setValue:errorDetails forKey:NSLocalizedDescriptionKey];
    *error = [NSError errorWithDomain:domain code:code userInfo:details];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    //[tracker sendException:NO withNSException:exception];
    [tracker sendException:NO withDescription:@"%@: %@",errorDetails, message];
    
}

- (NSString *) getServiceDetails:(NSString *)what why:(NSString *) why
{
    return [NSString stringWithFormat:errorFormat, what, why];
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
