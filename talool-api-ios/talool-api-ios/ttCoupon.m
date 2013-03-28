//
//  ttCoupon.m
//  mobile
//
//  Created by Douglas McCuen on 3/3/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttCoupon.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttCoupon


+ (ttCoupon *)initWithName:(NSString *)name context:(NSManagedObjectContext *)context
{
    ttCoupon *c = (ttCoupon *)[NSEntityDescription
                                   insertNewObjectForEntityForName:DEAL_ENTITY_NAME
                                   inManagedObjectContext:context];
    
    c.title = name;
    c.redeemed = [[NSNumber alloc] initWithBool:NO];
    
    
    return c;
}

- (BOOL) hasBeenRedeemed
{
    return (self.redeemed == [[NSNumber alloc] initWithBool:YES]);
}

@end
