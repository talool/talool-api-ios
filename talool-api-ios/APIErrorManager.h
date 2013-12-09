//
//  APIErrorManager.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/21/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

//
//  All the exception handling is repetitive in the controllers.
//  It would be nice to have a manager to catch and handle the exceptions.
//  So, this manager will:
//  - talk to a errorFactory to get an appropriate errorHandler
//  - manager all error codes and messages
//  - track exceptions
//

#import <Foundation/Foundation.h>
#import "APIErrorManager.h"

@class TaloolErrorHandler;

static NSString * TALOOL_DOMAIN = @"com.talool.talool-api-ios";

@protocol ErrorHandlerDelegate <NSObject>

- (void) handleServiceException:(NSException *)exception
                         domain:(NSString *)domain
                         method:(NSString *)method
                          error:(NSError **)error;

- (void) handleCoreDataException:(NSException *)exception
                          domain:(NSString *)domain
                          method:(NSString *)method
                          entity:(NSString *)entity
                           error:(NSError **)error;

- (void) handlePaymentException:(NSException *)exception
                          domain:(NSString *)domain
                          method:(NSString *)method
                         message:(NSString *)message
                           error:(NSError **)error;
@end

@interface APIErrorManager : NSObject {
    id <ErrorHandlerDelegate> handler;
}

enum {
    ERROR_HANDLER_CUSTOMER = 0,
    ERROR_HANDLER_MERCHANT = 1
};
typedef int ERROR_HANDLER_TYPE;

@property (retain) id handler;

- (void) setHandlerType:(ERROR_HANDLER_TYPE)type;

- (void) handleServiceException:(NSException *)exception
                      forMethod:(NSString *)method
                          error:(NSError **)error;

- (void) handleCoreDataException:(NSException *)exception
                       forMethod:(NSString *)method
                          entity:(NSString *)entity
                           error:(NSError **)error;

- (void) handlePaymentException:(NSException *)exception
                      forMethod:(NSString *)method
                        message:(NSString *)message
                          error:(NSError **)error;

// add a handler impl

@end
