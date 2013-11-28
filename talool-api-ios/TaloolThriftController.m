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

@implementation TaloolThriftController

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
    THTTPClient *transport;
    TBinaryProtocol *protocol;
    @try {
        // Talk to a server via socket, using a binary protocol
        /*
         NOTE: If you try to connect to a server/port that is down,
         the phone will crash with a EXC_BAD_ACCESS when this
         controller is gabage collected.
         */
        NSURL *url = [NSURL URLWithString:[[TaloolFrameworkHelper sharedInstance] getApiUrl]];
        transport = [[THTTPClient alloc] initWithURL:url
                                           userAgent:[[TaloolFrameworkHelper sharedInstance] getUserAgent]
                                             timeout:0];
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
