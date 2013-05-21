//
//  TaloolFrameworkHelper.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/9/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaloolFrameworkHelper : NSObject

+ (NSBundle *) frameworkBundle;

@end

extern NSString * const API_URL;

#define METERS_PER_MILE 1609.344
#define INFINITE_PROXIMITY 9999
#define MAX_PROXIMITY 200
#define DEFAULT_PROXIMITY 20
#define MIN_PROXIMITY 1
#define MIN_PROXIMITY_CHANGE_IN_MILES .05
