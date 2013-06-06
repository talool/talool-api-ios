//
//  ttFriend.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/6/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttFriend.h"
#import "ttCustomer.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttFriend

@synthesize fullName;

+ (ttFriend *)initWithThrift: (Customer_t *)customer context:(NSManagedObjectContext *)context
{
    ttFriend *f = (ttFriend *)[NSEntityDescription
                             insertNewObjectForEntityForName:FRIEND_ENTITY_NAME
                             inManagedObjectContext:context];
    
    f.firstName = customer.firstName;
    f.lastName = customer.lastName;
    f.fullName = [NSString stringWithFormat:@"%@ %@",customer.firstName, customer.lastName];
    f.email = customer.email;
    f.customerId = customer.customerId;
    
    return f;
}

@end
