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

+ (ttFriend *)initWithThrift: (Customer_t *)customer context:(NSManagedObjectContext *)context
{
    ttFriend *f = [ttFriend fetchById:customer.customerId context:context];
    
    f.firstName = customer.firstName;
    f.lastName = customer.lastName;
    f.email = customer.email;
    f.customerId = customer.customerId;
    
    return f;
}

+ (ttFriend *)initWithName:(NSString *)name email:(NSString *)email context:(NSManagedObjectContext *)context
{
    ttFriend *f = [ttFriend fetchByEmail:email context:context];
    
    f.firstName = name;
    f.lastName = name;
    f.email = email;
    
    return f;
}

+ (ttFriend *) fetchById:(NSString *) entityId context:(NSManagedObjectContext *)context
{
    ttFriend *friend = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.customerId = %@",entityId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:FRIEND_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    
    if (fetchedObj == nil || [fetchedObj count] == 0)
    {
        friend = (ttFriend *)[NSEntityDescription
                                  insertNewObjectForEntityForName:FRIEND_ENTITY_NAME
                                  inManagedObjectContext:context];
    }
    else
    {
        friend = [fetchedObj objectAtIndex:0];
    }
    return friend;
}

+ (ttFriend *) fetchByEmail:(NSString *)email context:(NSManagedObjectContext *)context
{
    ttFriend *friend = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.email = %@",email];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:FRIEND_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    
    if (fetchedObj == nil || [fetchedObj count] == 0)
    {
        friend = (ttFriend *)[NSEntityDescription
                              insertNewObjectForEntityForName:FRIEND_ENTITY_NAME
                              inManagedObjectContext:context];
    }
    else
    {
        friend = [fetchedObj objectAtIndex:0];
    }
    return friend;
}

- (NSString *) fullName
{
    return [NSString stringWithFormat:@"%@ %@",self.firstName, self.lastName];
}

@end
