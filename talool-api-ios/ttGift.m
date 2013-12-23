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
#import "GiftController.h"
#import "TaloolPersistentStoreCoordinator.h"
#import <APIErrorManager.h>

@implementation ttGift



#pragma mark -
#pragma mark - Create or Update the Core Data Object

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



#pragma mark -
#pragma mark - Convenience methods

- (ttDealAcquire *) getDealAquire:(NSManagedObjectContext *)context
{
    ttDealAcquire *deal;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.deal.dealId = %@",self.deal.dealId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:DEAL_ACQUIRE_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    
    if (fetchedObj != nil && [fetchedObj count] == 1)
    {
        deal = [fetchedObj objectAtIndex:0];
    }
    else if (fetchedObj != nil && [fetchedObj count] > 1)
    {
        for (int i=0; i<[fetchedObj count]; i++) {
            deal = [fetchedObj objectAtIndex:i];
            if (deal.status == [NSNumber numberWithInt:AcquireStatus_t_PURCHASED] ||
                deal.status == [NSNumber numberWithInt:AcquireStatus_t_ACCEPTED_CUSTOMER_SHARE] ||
                deal.status == [NSNumber numberWithInt:AcquireStatus_t_ACCEPTED_MERCHANT_SHARE])
            {
                break;
            }
        }
    }
    return deal;
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



#pragma mark -
#pragma mark - Gift Management

+ (BOOL) getGiftById:(NSString* )giftId customer:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)err
{
    BOOL result = NO;
    GiftController *gc = [[GiftController alloc] init];
    Gift_t *gift = [gc getGiftById:giftId customer:customer error:err];
    if (gift)
    {
        @try {
            // transform the Thrift response
            [ttGift initWithThrift:gift context:context];
            result = [context save:err];
        }
        @catch (NSException * e) {
            [gc.errorManager handleCoreDataException:e forMethod:@"getGiftById" entity:@"ttGift" error:err];
        }
        
    }
    return result;
}

+ (NSString *) giftToFacebook:(NSString *)dealAcquireId
               customer:(ttCustomer *)customer
             facebookId:(NSString *)facebookId
         receipientName:(NSString *)receipientName
                  error:(NSError**)error
{
    GiftController *gc = [[GiftController alloc] init];
    return [gc giftToFacebook:customer dealAcquireId:dealAcquireId facebookId:facebookId receipientName:receipientName error:error];
}

+ (NSString *) giftToEmail:(NSString *)dealAcquireId
            customer:(ttCustomer *)customer
               email:(NSString *)email
      receipientName:(NSString *)receipientName
               error:(NSError**)error
{
    GiftController *gc = [[GiftController alloc] init];
    return [gc giftToEmail:customer dealAcquireId:dealAcquireId email:email receipientName:receipientName error:error];
}

+ (BOOL) acceptGift:(NSString *)giftId
           customer:(ttCustomer *)customer
            context:(NSManagedObjectContext *)context
              error:(NSError**)error;
{
    BOOL result = NO;
    GiftController *gc = [[GiftController alloc] init];
    DealAcquire_t *deal = [gc acceptGift:customer giftId:giftId error:error];
    
    if (deal)
    {
        @try {
            // transform the Thrift response
            [ttDealAcquire initWithThrift:deal context:context];
            
            ttGift *gift = [ttGift fetchById:giftId context:context];
            if (gift)
            {
                gift.giftStatus = [NSNumber numberWithInt:GiftStatus_t_ACCEPTED];
            }
            
            result = [context save:error];
        }
        @catch (NSException * e) {
            [gc.errorManager handleCoreDataException:e forMethod:@"acceptGift" entity:@"ttGift" error:error];
        }
    }
    
    
    return result;
}

+ (BOOL) rejectGift:(NSString *)giftId
           customer:(ttCustomer *)customer
            context:(NSManagedObjectContext *)context
              error:(NSError**)error
{
    GiftController *gc = [[GiftController alloc] init];
    BOOL result = [gc rejectGift:customer giftId:giftId error:error];
    
    if (result)
    {
        ttGift *gift = [ttGift fetchById:giftId context:context];
        if (gift)
        {
            gift.giftStatus = [NSNumber numberWithInt:GiftStatus_t_REJECTED];
        }
        
        result = [context save:error];
    }
    
    return result;
}


@end
