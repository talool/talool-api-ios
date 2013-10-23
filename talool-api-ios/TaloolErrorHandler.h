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
    ErrorCode_NETWORK_DOWN                          = -1009,
    ErrorCode_SERVICE_DOWN                          = -1,
    ErrorCode_UNKNOWN                               = 0,
    ErrorCode_NOT_FOUND_EXCEPTION                   = 1,
    ErrorCode_APP_FAIL                              = 2,
    ErrorCode_CORE_DATA                             = 3,
    ErrorCode_VALID_EMAIL_REQUIRED                  = 100,
    ErrorCode_PASS_REQUIRED                         = 101,
    ErrorCode_PASS_CONFIRM_MUST_MATCH               = 102,
    ErrorCode_PASS_RESET_CODE_REQUIRED              = 103,
    ErrorCode_PASS_RESET_CODE_EXPIRED               = 104,
    ErrorCode_PASS_RESET_CODE_INVALID               = 105,
    ErrorCode_EMAIL_ALREADY_TAKEN                   = 1000,
    ErrorCode_INVALID_USERNAME_OR_PASSWORD          = 1001,
    ErrorCode_CUSTOMER_DOES_NOT_OWN_DEAL            = 1002,
    ErrorCode_DEAL_ALREADY_REDEEMED                 = 1003,
    ErrorCode_GIFTING_NOT_ALLOWED                   = 1004,
    ErrorCode_CUSTOMER_NOT_FOUND                    = 1005,
    ErrorCode_EMAIL_REQUIRED                        = 1006,
    ErrorCode_EMAIL_OR_PASS_INVALID                 = 1007, // NOT BEING PASSED FROM SERVICE?
    ErrorCode_NOT_GIFT_RECIPIENT                    = 1008,
                                                            // xxxx - already accepted
    ErrorCode_GENERAL_PROCESSOR_ERROR               = 1500, // NOT BEING PASSED FROM SERVICE?
    ErrorCode_ACTIVIATION_CODE_NOT_FOUND            = 3000,
    ErrorCode_ACTIVIATION_CODE_ALREADY_ACTIVATED    = 3001
};
typedef int ErrorCode;

@end
