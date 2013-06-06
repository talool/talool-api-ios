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

static NSString *errorFormat = @"Failed %@.  Reason: %@";

@implementation TaloolErrorHandler

- (void) handleServiceException:(NSException *)exception domain:(NSString *)domain method:(NSString *)method error:(NSError **)error
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    NSString *errorDetails;
    TaloolErrorCodeType code;
    
    if ([exception isKindOfClass:[ServiceException_t class]])
    {
        errorDetails = [self getServiceDetails:method why:@"The Service Failed"];
        code = ERROR_CODE_SERVICE_DOWN;
    }
    else if ([exception isKindOfClass:[TApplicationException class]])
    {
        errorDetails = [self getServiceDetails:method why:@"The App Failed"];
        code = ERROR_CODE_APP_FAIL;
    }
    else if ([exception isKindOfClass:[TTransportException class]])
    {
        errorDetails = [self getServiceDetails:method why:@"The Server Barfed"];
        code = ERROR_CODE_TOMCAT_DOWN;
    }
    else
    {
        errorDetails = [self getServiceDetails:method why:@"... who knows why ..."];
        code = ERROR_CODE_DEFAULT;
    }
    
    [details setValue:errorDetails forKey:NSLocalizedDescriptionKey];
    
    *error = [NSError errorWithDomain:domain code:code userInfo:details];
    
    NSLog(@"%@: %@",errorDetails, exception.description);
    
}

- (void) handleCoreDataException:(NSException *)exception domain:(NSString *)domain method:(NSString *)method entity:(NSString *)entity error:(NSError **)error
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    NSString *errorDetails = [self getCoreDataDetails:method where:entity];
    
    TaloolErrorCodeType code = ERROR_CODE_CORE_DATA;
    
    [details setValue:errorDetails forKey:NSLocalizedDescriptionKey];
    *error = [NSError errorWithDomain:domain code:code userInfo:details];
    
    NSLog(@"%@: %@",errorDetails, exception.description);
    
}

- (NSString *) getServiceDetails:(NSString *)what why:(NSString *) why
{
    return [NSString stringWithFormat:errorFormat, what, why];
}

- (NSString *) getCoreDataDetails:(NSString *)what where:(NSString *)where
{
    return [NSString stringWithFormat:errorFormat, what, where];
}

@end