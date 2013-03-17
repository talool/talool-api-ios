//
//  TaloolHTTPClient.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/16/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THTTPClient.h"

@interface TaloolHTTPClient : THTTPClient

- (NSMutableURLRequest *) getRequest;

@end
