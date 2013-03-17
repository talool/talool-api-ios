//
//  ttSocialAccount.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/13/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialAccount.h"

@class SocialAccount_t;

@interface ttSocialAccount : SocialAccount

- (BOOL)isValid;
+ (ttSocialAccount *)initWithThrift: (SocialAccount_t *)sa context:(NSManagedObjectContext *)context;
- (SocialAccount_t *)hydrateThriftObject;

@end
