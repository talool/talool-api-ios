//
//  ttMerchant.m
//  mobile
//
//  Created by Douglas McCuen on 3/2/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttMerchant.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttMerchant

@synthesize name, email;

-(BOOL)isValid
{
    return TRUE;
}

+(ttMerchant *)initWithThrift:(Merchant_t *)merchant context:(NSManagedObjectContext *)context
{
    ttMerchant *m = (ttMerchant *)[NSEntityDescription
                                   insertNewObjectForEntityForName:MERCHANT_ENTITY_NAME
                                   inManagedObjectContext:context];


    
    return m;
}

-(Merchant_t *)hydrateThriftObject
{
    Merchant_t *merchant = nil;//[[Merchant_t alloc] init];

    return merchant;
}

@end
