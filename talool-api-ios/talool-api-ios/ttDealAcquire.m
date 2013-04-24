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
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"
#import "CustomerController.h"

@implementation ttDealAcquire

@synthesize customer;

+ (ttDealAcquire *)initWithThrift: (DealAcquire_t *)deal context:(NSManagedObjectContext *)context;
{
    ttDealAcquire *newDeal = (ttDealAcquire *)[NSEntityDescription
                                 insertNewObjectForEntityForName:DEAL_ACQUIRE_ENTITY_NAME
                                 inManagedObjectContext:context];
    
    newDeal.dealAcquireId = deal.dealAcquireId;
    newDeal.deal = [ttDeal initWithThrift:deal.deal context:context];
    newDeal.status = deal.status;
    newDeal.shareCount = [[NSNumber alloc] initWithUnsignedInteger:deal.shareCount];
    if (deal.redeemed != 0) {
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

- (void)redeemHere:(double)latitude longitude:(double)longitude error:(NSError**)error
{
    CustomerController *cController = [[CustomerController alloc] init];
    
    if ([cController redeem:self latitude:latitude longitude:longitude error:error])
    {
        [self setRedeemed:[[NSDate alloc] initWithTimeIntervalSinceNow:0]];
    }
    
    
}

@end
