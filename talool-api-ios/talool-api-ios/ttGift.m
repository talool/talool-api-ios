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
    ttGift *newGift = (ttGift *)[NSEntityDescription
                                 insertNewObjectForEntityForName:GIFT_ENTITY_NAME
                                 inManagedObjectContext:context];

    newGift.giftId = gift.giftId;
    newGift.created = [[NSDate alloc] initWithTimeIntervalSince1970:(gift.created/1000)];
    ttMerchant *merch = [ttMerchant initWithThrift:gift.deal.merchant context:context];
    newGift.deal = [ttDeal initWithThrift:gift.deal merchant:merch context:context];
    newGift.fromCustomer = [ttFriend initWithThrift:gift.fromCustomer context:context];
    
    return newGift;
}

+ (ttGift *)getGiftById:(NSString* )giftId customer:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)err
{
    /* query the context for these deals
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.giftId = %@",giftId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:GIFT_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSMutableArray *gifts = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (gifts == nil || [gifts count] == 0) {
        NSLog(@"FAIL: Nil gift for giftId: %@: %@",giftId, error.localizedDescription);
        return nil;
    }
    ttGift *gift = [gifts objectAtIndex:0];
     */
    
    CustomerController *cc = [[CustomerController alloc] init];
    ttGift *gift = [cc getGiftById:customer context:context error:err];
    return gift;
}

- (Gift_t *)hydrateThriftObject
{
    Gift_t *gift = [[Gift_t alloc] init];
    
    gift.giftId = self.giftId;
    gift.deal = [(ttDeal *)self.deal hydrateThriftObject];
    
    return gift;
}

@end
