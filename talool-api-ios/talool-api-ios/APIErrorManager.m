//
//  APIErrorManager.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/21/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "APIErrorManager.h"
#import "TaloolErrorHandler.h"

NSString * const TALOOL_DOMAIN = @"com.talool.talool-api-ios";

@implementation APIErrorManager

@synthesize handler;

-(id) init
{
    self = [super init];
    self.handler = [[TaloolErrorHandler alloc] init];
    return self;
}

- (void) setHandlerType:(ERROR_HANDLER_TYPE)type
{
    self.handler = [[TaloolErrorHandler alloc] init];
}

- (void) handleServiceException:(NSException *)exception forMethod:(NSString *)method error:(NSError **)error
{
    [handler handleServiceException:exception domain:TALOOL_DOMAIN method:method error:error];
}

- (void) handleCoreDataException:(NSException *)exception forMethod:(NSString *)method entity:(NSString *)entity error:(NSError **)error
{
    [handler handleCoreDataException:exception domain:TALOOL_DOMAIN method:method entity:(NSString *)entity error:error];
}

@end
