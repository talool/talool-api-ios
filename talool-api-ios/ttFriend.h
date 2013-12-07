//
//  ttFriend.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/6/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "Friend.h"

@class Customer_t;

@interface ttFriend : Friend

+ (ttFriend *)initWithThrift: (Customer_t *)customer context:(NSManagedObjectContext *)context;
+ (ttFriend *)initWithName:(NSString *)name email:(NSString *)email context:(NSManagedObjectContext *)context;

- (NSString *) fullName;

@end
