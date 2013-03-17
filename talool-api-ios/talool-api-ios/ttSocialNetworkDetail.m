//
//  ttSocialNetworkDetail.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/13/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttSocialNetworkDetail.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttSocialNetworkDetail

- (BOOL)isValid
{
    return YES;
}
+ (ttSocialNetworkDetail *)initWithThrift: (SocialNetworkDetail_t *)snd context:(NSManagedObjectContext *)context
{
    ttSocialNetworkDetail *ttsnd = (ttSocialNetworkDetail *)[NSEntityDescription
                                                  insertNewObjectForEntityForName:SOCIAL_NETWORK_DETAIL_ENTITY_NAME
                                                  inManagedObjectContext:context];
    
    return ttsnd;
}

- (SocialNetworkDetail_t *)hydrateThriftObject
{
    SocialNetworkDetail_t *snd = [[SocialNetworkDetail_t alloc] init];
    
    return snd;
}

@end
