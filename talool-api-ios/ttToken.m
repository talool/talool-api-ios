//
//  ttToken.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/16/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttToken.h"
#import "ttCustomer.h"
#import "TaloolPersistentStoreCoordinator.h"
#import "CustomerService.h"

@implementation ttToken

+ (ttToken *)initWithThrift: (CTokenAccess_t *)token context:(NSManagedObjectContext *)context
{
    ttToken *t = (ttToken *)[NSEntityDescription
                             insertNewObjectForEntityForName:TOKEN_ENTITY_NAME
                                      inManagedObjectContext:context];
    
    t.customer = [ttCustomer initWithThrift:token.customer context:context];
    t.token = token.token;
    
    return t;
}

@end
