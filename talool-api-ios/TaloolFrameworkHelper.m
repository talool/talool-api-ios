//
//  TaloolFrameworkHelper.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/9/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolFrameworkHelper.h"

NSString * const API_URL = @"https://api.talool.com/1.1";
NSString * const VENMO_SDK_SESSION = @"venmo_sdk_session";

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

@end

