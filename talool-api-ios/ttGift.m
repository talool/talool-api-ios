//
//  ttGift.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/4/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttGift.h"
#import "ttFriend.h"
#import "ttDeal.h"
#import "ttMerchant.h"
#import "ttDealAcquire.h"
#import "Core.h"
#import "CustomerController.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttGift

+ (ttGift *)initWithThrift: (Gift_t *)gift context:(NSManagedObjectContext *)context
{
    ttGift *newGift = [ttGift fetchById:gift.giftId context:context];

    newGift.giftId = gift.giftId;
    newGift.created = [[NSDate alloc] initWithTimeIntervalSince1970:(gift.created/1000)];
    ttMerchant *merch = [ttMerchant initWithThrift:gift.deal.merchant context:context];
    newGift.deal = [ttDeal initWithThrift:gift.deal merchant:merch context:context];
    newGift.fromCustomer = [ttFriend initWithThrift:gift.fromCustomer context:context];
    newGift.giftStatus = [NSNumber numberWithInt:gift.giftStatus];
    
    return newGift;
}

+ (ttGift *)getGiftById:(NSString* )giftId customer:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)err
{
    
    CustomerController *cc = [[CustomerController alloc] init];
    ttGift *gift = [cc getGiftById:giftId customer:customer context:context error:err];
    return gift;
}

+ (ttGift *) fetchById:(NSString *) giftId context:(NSManagedObjectContext *)context
{
    ttGift *gift = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.giftId = %@",giftId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:GIFT_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    
    if (fetchedObj == nil || [fetchedObj count] == 0)
    {
        gift = (ttGift *)[NSEntityDescription
                          insertNewObjectForEntityForName:GIFT_ENTITY_NAME
                          inManagedObjectContext:context];
    }
    else
    {
        gift = [fetchedObj objectAtIndex:0];
    }
    return gift;
}

- (BOOL) isPending
{
    return (self.giftStatus == [NSNumber numberWithInt:GiftStatus_t_PENDING]);
}
- (BOOL) isAccepted
{
    return (self.giftStatus == [NSNumber numberWithInt:GiftStatus_t_ACCEPTED]);
}
- (BOOL) isRejected
{
    return (self.giftStatus == [NSNumber numberWithInt:GiftStatus_t_REJECTED]);
}
- (BOOL) isInvalidated
{
    return (self.giftStatus == [NSNumber numberWithInt:GiftStatus_t_INVALIDATED]);
}

- (Gift_t *)hydrateThriftObject
{
    Gift_t *gift = [[Gift_t alloc] init];
    
    gift.giftId = self.giftId;
    gift.deal = [(ttDeal *)self.deal hydrateThriftObject];
    
    return gift;
}

@end
