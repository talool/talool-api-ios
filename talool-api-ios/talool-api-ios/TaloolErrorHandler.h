//
//  TaloolErrorHandler.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/21/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIErrorManager.h"

@interface TaloolErrorHandler : NSObject<ErrorHandlerDelegate>

enum {
    ERROR_CODE_DEFAULT = 100,
    ERROR_CODE_SERVICE_DOWN = 200,
    ERROR_CODE_APP_FAIL = 300,
    ERROR_CODE_TOMCAT_DOWN = 500,
    ERROR_CODE_CORE_DATA = 600
};
typedef int TaloolErrorCodeType;


// TODO
//- (TaloolErrorCodeType) getCodeForServiceException:(NSString *)method;
//- (TaloolErrorCodeType) getCodeForApplicationException:(NSString *)method;
//- (TaloolErrorCodeType) getCodeForTomcatException:(NSString *)method;

@end
