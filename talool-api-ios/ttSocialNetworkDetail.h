//
//  ttSocialNetworkDetail.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/13/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SocialNetworkDetail.h"

@class SocialNetworkDetail_t;

@interface ttSocialNetworkDetail : NSObject

+ (ttSocialNetworkDetail *)initWithThrift: (SocialNetworkDetail_t *)snd context:(NSManagedObjectContext *)context;

@end



