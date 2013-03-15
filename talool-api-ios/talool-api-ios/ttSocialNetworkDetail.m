//
//  ttSocialNetworkDetail.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/13/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttSocialNetworkDetail.h"
#import "Core.h"

@implementation ttSocialNetworkDetail

- (BOOL)isValid
{
    return YES;
}
+ (ttSocialNetworkDetail *)initWithThrift: (SocialNetworkDetail_t *)snd
{
    ttSocialNetworkDetail *ttsnd = [ttSocialNetworkDetail alloc];
    
    return ttsnd;
}

- (SocialNetworkDetail_t *)hydrateThriftObject
{
    SocialNetworkDetail_t *snd = [[SocialNetworkDetail_t alloc] init];
    
    return snd;
}

@end
