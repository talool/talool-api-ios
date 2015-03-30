//
//  TaloolThriftController.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/27/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolThriftController.h"
#import "THTTPClient.h"
#import "TBinaryProtocol.h"
#import "TTransportException.h"
#import "TaloolHTTPClient.h"
#import "APIErrorManager.h"
#import "CustomerService.h"
#import "TaloolFrameworkHelper.h"
#import "ttToken.h"
#import <UIKit/UIDevice.h>
#import "TaloolFrameworkHelper.h"

@implementation TaloolThriftController
NSString* const APN_DEVICE_TOKEN_HEADER = @"ApnDeviceToken";
NSString* const DEVICE_ID_HEADER = @"DeviceId";
NSString* const FREE_BOOK_HEADER = @"X-Supports-Free-Books";
NSString* const WHITE_LABEL_HEADER = @"X-White-Label-Id";
@synthesize service, errorManager;

- (id)init
{
	if ((self = [super init])) {
        errorManager = [[APIErrorManager alloc] init];
	}
	return self;
}

- (void)connect
{
    TaloolHTTPClient *transport;
    TBinaryProtocol *protocol;
    @try {
        // Talk to a server via socket, using a binary protocol
        /*
         NOTE: If you try to connect to a server/port that is down,
         the phone will crash with a EXC_BAD_ACCESS when this
         controller is gabage collected.
         */
        NSURL *url = [NSURL URLWithString:[[TaloolFrameworkHelper sharedInstance] getApiUrl]];
        transport = [[TaloolHTTPClient alloc] initWithURL:url
                                                userAgent:[[TaloolFrameworkHelper sharedInstance] getUserAgent]
                                                  timeout:0];
        [[transport getRequest] setValue:[TaloolFrameworkHelper sharedInstance].whiteLabelId
                      forHTTPHeaderField:WHITE_LABEL_HEADER];
        protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
        service = [[CustomerService_tClient alloc] initWithProtocol:protocol];
    } @catch(NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
}

- (void)connectWithToken:(ttToken *)token
{
    TaloolHTTPClient *transport;
    TBinaryProtocol *protocol;
    @try {
        NSURL *url = [NSURL URLWithString:[[TaloolFrameworkHelper sharedInstance] getApiUrl]];
        transport = [[TaloolHTTPClient alloc] initWithURL:url
                                                userAgent:[[TaloolFrameworkHelper sharedInstance] getUserAgent]
                                                  timeout:0];
        [[transport getRequest] setValue:token.token forHTTPHeaderField:CustomerServiceConstants.CTOKEN_NAME];
        [[transport getRequest] setValue:[TaloolFrameworkHelper sharedInstance].whiteLabelId
                       forHTTPHeaderField:WHITE_LABEL_HEADER];
        
        //Add free book support
        [[transport getRequest] setValue:@"1" forHTTPHeaderField:FREE_BOOK_HEADER];
        
        //Add deviceId for app
        NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
        [[transport getRequest] setValue:[uuid UUIDString] forHTTPHeaderField:DEVICE_ID_HEADER];
        
        //Add APN Device Token for device
        NSData* apnDeviceToken = [TaloolFrameworkHelper sharedInstance].apnDeviceToken;
        if (apnDeviceToken != nil) {
            NSString *b = [apnDeviceToken base64EncodedStringWithOptions:0];
            [[transport getRequest] setValue:b forHTTPHeaderField:APN_DEVICE_TOKEN_HEADER];
        }
        
        protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
        service = [[CustomerService_tClient alloc] initWithProtocol:protocol];
    } @catch(NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
}

-(void)disconnect
{
    service = nil;
}

@end
