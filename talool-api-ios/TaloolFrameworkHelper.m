//
//  TaloolFrameworkHelper.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/9/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolFrameworkHelper.h"

NSString * const VENMO_SDK_SESSION = @"venmo_sdk_session";

@interface TaloolFrameworkHelper ()
@property EnvironmentType envType;
@property NSString *userAgent;
@end

@implementation TaloolFrameworkHelper

+ (NSBundle *) frameworkBundle {
    static NSBundle* frameworkBundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
        NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:@"talool-api-ios.bundle"];
        frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
    });
    return frameworkBundle;
}

+ (TaloolFrameworkHelper *)sharedInstance
{
    static dispatch_once_t once;
    static TaloolFrameworkHelper * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.envType = EnvironmentTypeProduction;
    });
    return sharedInstance;
}

- (void) setEnvironment:(EnvironmentType)env;
{
    self.envType = env;
}
- (NSString *) getApiUrl
{
    return (self.envType == EnvironmentTypeProduction) ? API_URL_PROD:API_URL_DEV;
}

- (BOOL) isProduction
{
    return (self.envType == EnvironmentTypeProduction);
}

- (void) setUserAgent:(NSString *)appVersion iosVersion:(NSString *)iosVersion
{
    _userAgent = [NSString stringWithFormat:@"Talool/%@ (%@)",appVersion, iosVersion];
}

- (NSString *) getUserAgent
{
    return _userAgent;
}

@end

