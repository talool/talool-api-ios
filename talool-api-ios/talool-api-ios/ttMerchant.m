//
//  ttMerchant.m
//  mobile
//
//  Created by Douglas McCuen on 3/2/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttMerchant.h"
#import "ttMerchantLocation.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"
#import "MerchantController.h"
#import "CustomerController.h"

@implementation ttMerchant

+(ttMerchant *)initWithThrift:(Merchant_t *)merchant context:(NSManagedObjectContext *)context
{
    ttMerchant *m = (ttMerchant *)[NSEntityDescription
                                   insertNewObjectForEntityForName:MERCHANT_ENTITY_NAME
                                   inManagedObjectContext:context];

    m.merchantId = merchant.merchantId;
    m.name = merchant.name;
    m.created = [[NSDate alloc] initWithTimeIntervalSince1970:merchant.created];
    m.updated = [[NSDate alloc] initWithTimeIntervalSince1970:merchant.updated];
    
    if (merchant.locationsIsSet) {
        for (int i=0; i<[merchant.locations count]; i++) {
            MerchantLocation_t *mlt = [merchant.locations objectAtIndex:i];
            ttMerchantLocation *ml = [ttMerchantLocation initWithThrift:mlt context:context];
            [m addLocationsObject:ml];
        }
    }
    
    return m;
}

-(Merchant_t *)hydrateThriftObject
{
    Merchant_t *merchant = [[Merchant_t alloc] init];
    
    merchant.merchantId = self.merchantId;
    merchant.name = self.name;
    
    NSEnumerator *enumerator = [self.locations objectEnumerator];
    ttMerchantLocation *ml;
    MerchantLocation_t *mlt;
    int i=0;
    while (ml = [enumerator nextObject]) {
        mlt = [ml hydrateThriftObject];
        [merchant.locations setObject:mlt atIndexedSubscript:i++];
    }

    return merchant;
}

- (NSSet *) getDeals:(ttCustomer *)customer context:(NSManagedObjectContext *)context
{

    if ([self.deals count] > 0) {
        [self removeDeals:self.deals];
    }
    
    CustomerController *cc = [[CustomerController alloc] init];
    NSError *error = [NSError alloc];
    NSMutableArray *deals = [cc getAcquiredDeals:self forCustomer:customer context:context error:&error];
    NSSet *myDeals = [[NSSet alloc] initWithArray:deals];
    [self addDeals:myDeals];
    
    return myDeals;
}

@end
