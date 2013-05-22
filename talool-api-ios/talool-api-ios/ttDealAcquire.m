//
//  ttDealAcquire.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/22/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttDealAcquire.h"
#import "ttDeal.h"
#import "ttCustomer.h"
#import "ttMerchant.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"
#import "CustomerController.h"

@implementation ttDealAcquire

@synthesize customer;

+ (ttDealAcquire *)initWithThrift: (DealAcquire_t *)deal merchant:(ttMerchant *)merchant context:(NSManagedObjectContext *)context
{
    ttDealAcquire *newDeal = [ttDealAcquire fetchDealAcquireById:deal.dealAcquireId context:context];
    
    newDeal.dealAcquireId = deal.dealAcquireId;
    newDeal.deal = [ttDeal initWithThrift:deal.deal merchant:merchant context:context];
    newDeal.status = deal.status;
    newDeal.shareCount = [[NSNumber alloc] initWithUnsignedInteger:deal.shareCount];
    
    // don't override with the server value of the server returns null or if the client thinks it has been redeemed.
    if (deal.redeemedIsSet==YES && newDeal.redeemed == nil)
    {
        newDeal.redeemed = [[NSDate alloc] initWithTimeIntervalSince1970:deal.redeemed];
    }
    return newDeal;
}

- (DealAcquire_t *)hydrateThriftObject
{
    DealAcquire_t *acquire = [[DealAcquire_t alloc] init];
    acquire.dealAcquireId = self.dealAcquireId;
    acquire.deal = [(ttDeal *)self.deal hydrateThriftObject];
    acquire.shareCount = [self.shareCount integerValue];
    acquire.redeemed = [self.redeemed timeIntervalSince1970];
    
    return acquire;
}

- (BOOL) hasBeenRedeemed
{
    return (self.redeemed != NULL);
}

- (void)redeemHere:(double)latitude longitude:(double)longitude error:(NSError**)err context:(NSManagedObjectContext *)context
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    NSError *redeemError;
    
    CustomerController *cController = [[CustomerController alloc] init];
    [cController redeem:self latitude:latitude longitude:longitude error:&redeemError];
    
    if (redeemError.code < 100)
    {
        [self setRedeemed:[[NSDate alloc] initWithTimeIntervalSinceNow:0]];

        NSError *saveError;
        if (![context save:&saveError]) {
            NSLog(@"API: OH SHIT!!!! Failed to save context after redeemHere: %@ %@",saveError, [saveError userInfo]);
            [details setValue:@"Failed to save context after redeemHere." forKey:NSLocalizedDescriptionKey];
            *err = [NSError errorWithDomain:@"redeemHere" code:200 userInfo:details];
        }
        
    } else {
        [details setValue:@"Failed to redeem deal." forKey:NSLocalizedDescriptionKey];
        *err = [NSError errorWithDomain:@"redeemHere" code:200 userInfo:details];
    }
    
}

+ (ttDealAcquire *) fetchDealAcquireById:(NSString *) dealAcquireId context:(NSManagedObjectContext *)context
{
    ttDealAcquire *acquire = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.dealAcquireId = %@",dealAcquireId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:DEAL_ACQUIRE_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    
    if (fetchedObj == nil || [fetchedObj count] == 0)
    {
        acquire = (ttDealAcquire *)[NSEntityDescription
                                  insertNewObjectForEntityForName:DEAL_ACQUIRE_ENTITY_NAME
                                  inManagedObjectContext:context];
    }
    else
    {
        acquire = [fetchedObj objectAtIndex:0];
    }
    return acquire;
}

@end
