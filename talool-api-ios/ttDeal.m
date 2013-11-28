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
    ttDeal *newDeal = [ttDeal fetchDealById:deal.dealId context:context];
    
    newDeal.title = deal.title;
    newDeal.dealId = deal.dealId;
    newDeal.summary = deal.summary;
    newDeal.details = deal.details;
    newDeal.code = deal.code;
    newDeal.imageUrl = deal.imageUrl;
    
    if (deal.expires==0)
    {
        newDeal.expires = nil;
    }
    else
    {
        newDeal.expires = [[NSDate alloc] initWithTimeIntervalSince1970:(deal.expires/1000)];
    }
    
    newDeal.created = [[NSDate alloc] initWithTimeIntervalSince1970:(deal.created/1000)];
    newDeal.updated = [[NSDate alloc] initWithTimeIntervalSince1970:(deal.updated/1000)];
    newDeal.dealOfferId = deal.dealOfferId;
    
    if (merchant == nil)
    {
        newDeal.merchant = [ttMerchant initWithThrift:deal.merchant context:context];
    }
    else
    {
        newDeal.merchant = merchant;
    }
    
    return newDeal;
}

+ (ttDeal *) fetchDealById:(NSString *) dealId context:(NSManagedObjectContext *)context
{
    ttDeal *deal = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.dealId = %@",dealId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:DEAL_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    
    if (fetchedObj == nil || [fetchedObj count] == 0)
    {
        deal = (ttDeal *)[NSEntityDescription
                                  insertNewObjectForEntityForName:DEAL_ENTITY_NAME
                                  inManagedObjectContext:context];
    }
    else
    {
        deal = [fetchedObj objectAtIndex:0];
    }
    return deal;
}


@end
