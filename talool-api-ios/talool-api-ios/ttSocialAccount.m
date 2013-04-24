//
//  ttSocialAccount.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/13/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttSocialAccount.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttSocialAccount

- (BOOL)isValid
{
    return YES;
}

+ (ttSocialAccount *) createSocialAccount:(int *)socialNetwork
                                  loginId:(NSString *)loginId
                                    token:(NSString *)token
                                  context:(NSManagedObjectContext *)context
{
    
    ttSocialAccount *sa = (ttSocialAccount *)[NSEntityDescription
                                              insertNewObjectForEntityForName:SOCIAL_ACCOUNT_ENTITY_NAME
                                              inManagedObjectContext:context];
    
    sa.loginId = loginId;
    sa.socialNetwork = [[NSNumber alloc] initWithInt:1]; // TODO use the values defined in thrift, or the persistence helper
    return sa;
}

+ (ttSocialAccount *)initWithThrift: (SocialAccount_t *)sa context:(NSManagedObjectContext *)context
{
    ttSocialAccount *ttsa = (ttSocialAccount *)[NSEntityDescription
                                           insertNewObjectForEntityForName:SOCIAL_ACCOUNT_ENTITY_NAME
                                           inManagedObjectContext:context];
    ttsa.loginId = sa.loginId;
    ttsa.socialNetwork = [[NSNumber alloc] initWithInt:sa.socalNetwork];
    return ttsa;
}

- (SocialAccount_t *)hydrateThriftObject
{
    SocialAccount_t *sa = [[SocialAccount_t alloc] init];
    sa.loginId = self.loginId;
    sa.socalNetwork = [self.socialNetwork intValue];
    return sa;
}

@end
