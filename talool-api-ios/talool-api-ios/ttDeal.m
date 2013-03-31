//
//  ttCoupon.m
//  mobile
//
//  Created by Douglas McCuen on 3/3/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttDeal.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttDeal

+ (ttDeal *)initWithThrift: (Deal_t *)deal context:(NSManagedObjectContext *)context;
{
    ttDeal *newDeal = (ttDeal *)[NSEntityDescription
                                          insertNewObjectForEntityForName:DEAL_ENTITY_NAME
                                          inManagedObjectContext:context];
    newDeal.title = deal.title;
    newDeal.dealId = @(deal.dealId);
    newDeal.summary = deal.summary;
    newDeal.details = deal.details;
    newDeal.code = deal.code;
    newDeal.imageUrl = deal.imageUrl;
    newDeal.expires = [[NSDate alloc] initWithTimeIntervalSince1970:deal.expires];
    newDeal.created = [[NSDate alloc] initWithTimeIntervalSince1970:deal.created];
    newDeal.updated = [[NSDate alloc] initWithTimeIntervalSince1970:deal.updated];
    
    // TODO redeemedOn
    // TODO redeemed
    newDeal.redeemed = 0;
    
    return newDeal;
}

+ (ttDeal *)initWithName:(NSString *)name context:(NSManagedObjectContext *)context
{
    ttDeal *c = (ttDeal *)[NSEntityDescription
                                   insertNewObjectForEntityForName:DEAL_ENTITY_NAME
                                   inManagedObjectContext:context];
    
    c.title = name;
    c.redeemed = [[NSNumber alloc] initWithBool:NO];
    
    
    return c;
}

- (Deal_t *)hydrateThriftObject
{
    Deal_t *deal = [[Deal_t alloc] init];
    deal.dealId = [self.dealId integerValue];
    deal.title = self.title;
    deal.details = self.details;
    deal.summary = self.summary;
    deal.code = self.code;
    deal.imageUrl = self.imageUrl;
    deal.expires = [self.expires timeIntervalSince1970];
    
    // TODO redeemedOn
    // TODO redeemed
    
    return deal;
}

- (BOOL) hasBeenRedeemed
{
    return (self.redeemed == [[NSNumber alloc] initWithBool:YES]);
}

@end
