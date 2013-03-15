//
//  ttSocialAccount.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/13/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttSocialAccount.h"
#import "Core.h"

@implementation ttSocialAccount

- (BOOL)isValid
{
    return YES;
}

+ (ttSocialAccount *)initWithThrift: (SocialAccount_t *)sa
{
    ttSocialAccount *ttsa = [ttSocialAccount alloc];
    ttsa.token = sa.token;
    ttsa.loginId = sa.loginId;
    ttsa.socialNetwork = [[NSNumber alloc] initWithInt:sa.socalNetwork];
    return ttsa;
}

- (SocialAccount_t *)hydrateThriftObject
{
    SocialAccount_t *sa = [[SocialAccount_t alloc] init];
    sa.token = self.token;
    sa.loginId = self.loginId;
    sa.socalNetwork = [self.socialNetwork intValue];
    return sa;
}

@end
