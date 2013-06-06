//
//  ttCoupon.m
//  mobile
//
//  Created by Douglas McCuen on 3/3/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttDeal.h"
#import "ttMerchant.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttDeal

+ (ttDeal *)initWithThrift: (Deal_t *)deal merchant:(ttMerchant *)merchant context:(NSManagedObjectContext *)context;
{
    ttDeal *newDeal = (ttDeal *)[NSEntityDescription
                                          insertNewObjectForEntityForName:DEAL_ENTITY_NAME
                                          inManagedObjectContext:context];
    newDeal.title = deal.title;
    newDeal.dealId = deal.dealId;
    newDeal.summary = deal.summary;
    newDeal.details = deal.details;
    newDeal.code = deal.code;
    newDeal.imageUrl = deal.imageUrl;
    newDeal.expires = [[NSDate alloc] initWithTimeIntervalSince1970:deal.expires];
    newDeal.created = [[NSDate alloc] initWithTimeIntervalSince1970:deal.created];
    newDeal.updated = [[NSDate alloc] initWithTimeIntervalSince1970:deal.updated];
    newDeal.dealOfferId = deal.dealOfferId;
    
    newDeal.merchant = merchant;
    
    return newDeal;
}

+ (ttDeal *)initWithName:(NSString *)name context:(NSManagedObjectContext *)context
{
    ttDeal *c = (ttDeal *)[NSEntityDescription
                                   insertNewObjectForEntityForName:DEAL_ENTITY_NAME
                                   inManagedObjectContext:context];
    
    c.title = name;
    
    
    return c;
}

- (Deal_t *)hydrateThriftObject
{
    Deal_t *deal = [[Deal_t alloc] init];
    deal.dealId = self.dealId;
    deal.title = self.title;
    deal.details = self.details;
    deal.summary = self.summary;
    deal.code = self.code;
    deal.imageUrl = self.imageUrl;
    deal.expires = [self.expires timeIntervalSince1970];
    deal.dealOfferId = self.dealOfferId;
    
    return deal;
}


@end
