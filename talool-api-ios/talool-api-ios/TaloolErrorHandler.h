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
    ERROR_CODE_SERVICE_DOWN = 1,
    ERROR_CODE_NOT_FOUND_EXCEPTION = 2,
    ERROR_CODE_APP_FAIL = 3,
    ERROR_CODE_CORE_DATA = 4,
    ERROR_CODE_NETWORK_DOWN = -1009
};
typedef int TaloolErrorCodeType;

@end
