//
//  ttMerchant.m
//  mobile
//
//  Created by Douglas McCuen on 3/2/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttMerchant.h"
#import "ttAddress.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"
#import "MerchantController.h"

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

    m.merchantId = @(merchant.merchantId);
    m.name = merchant.name;
    m.email = merchant.email;
    m.websiteUrl = merchant.websiteUrl;
    m.logoUrl = merchant.logoUrl;
    m.phone = merchant.phone;
    m.address = [ttAddress initWithThrift:merchant.address context:context];
    m.created = [[NSDate alloc] initWithTimeIntervalSince1970:merchant.created];
    m.updated = [[NSDate alloc] initWithTimeIntervalSince1970:merchant.updated];
    
    return m;
}

-(Merchant_t *)hydrateThriftObject
{
    Merchant_t *merchant = [[Merchant_t alloc] init];
    
    merchant.merchantId = [self.merchantId integerValue];
    merchant.name = self.name;
    merchant.email = self.email;
    merchant.websiteUrl = self.websiteUrl;
    merchant.logoUrl = self.logoUrl;
    merchant.phone = self.phone;
    merchant.address = [(ttAddress *)self.address hydrateThriftObject];

    return merchant;
}

- (NSSet *) getDeals: (NSManagedObjectContext *)context
{
    // TODO this will be part of the Thrift Object
    if ([self.deals count] > 0) {
        [self removeDeals:self.deals];
    }
    MerchantController *mc = [[MerchantController alloc] init];
    NSSet *newDeals = [[NSSet alloc] initWithArray:[mc getCouponsByMerchant:self forCustomer:nil context:context]];
    [self addDeals:newDeals];
    return newDeals;
}

@end
