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
#import "ttFriend.h"
#import "TaloolCustomerUX.h"
#import "ttMerchant.h"
#import "ttGiftDetail.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"
#import "DealAcquireController.h"
#import "APIErrorManager.h"


@implementation ttDealAcquire


#pragma mark -
#pragma mark - Create or Update the Core Data Object

+ (ttDealAcquire *)initWithThrift: (DealAcquire_t *)deal merchant:(ttMerchant *)merchant context:(NSManagedObjectContext *)context
{
    ttDealAcquire *newDeal = [ttDealAcquire fetchDealAcquireById:deal.dealAcquireId context:context];
    
    newDeal.dealAcquireId = deal.dealAcquireId;
    newDeal.deal = [ttDeal initWithThrift:deal.deal merchant:merchant context:context];
    newDeal.status = [[NSNumber alloc] initWithUnsignedInteger:deal.status];
    newDeal.redemptionCode = deal.redemptionCode;
    
    // don't override with the server value of the server returns null or if the client thinks it has been redeemed.
    if (deal.redeemedIsSet==YES && newDeal.redeemed == nil)
    {
        newDeal.redeemed = [[NSDate alloc] initWithTimeIntervalSince1970:(deal.redeemed/1000)];
        newDeal.invalidated = newDeal.redeemed;
    }
    
    if ([newDeal hasExpired])
    {
        newDeal.invalidated = newDeal.deal.expires;
    }
    
    if ([newDeal hasBeenShared] && newDeal.invalidated==nil)
    {
        NSString *str =@"3/15/2013"; // old date to keep these deals sorts at the bottom
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        newDeal.invalidated = [formatter dateFromString:str];
    }
    
    if ([deal giftDetailIsSet])
    {
        newDeal.giftDetail = [ttGiftDetail initWithThrift:deal.giftDetail context:context];
    }
    
    return newDeal;
}

+ (ttDealAcquire *)initWithThrift: (DealAcquire_t *)deal context:(NSManagedObjectContext *)context
{
    return [ttDealAcquire initWithThrift:deal merchant:nil context:context];
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



#pragma mark -
#pragma mark - Convenience methods

- (BOOL) hasBeenRedeemed
{
    return (self.redeemed != NULL);
}

- (BOOL) hasBeenShared
{
    return ([self.status intValue] == AcquireStatus_t_PENDING_ACCEPT_CUSTOMER_SHARE);
}

- (BOOL) hasExpired
{
    NSDate *now = [NSDate date];
    if (self.deal.expires == nil) {
        return NO;
    }
    //else if (self.deal.expires < [NSDate date])
    else if ([now compare:self.deal.expires] == NSOrderedDescending)
    {
        return YES;
    }
    return NO;
}



#pragma mark -
#pragma mark - Mark as shared

- (BOOL) setSharedWith:(ttFriend *)taloolFriend error:(NSError**)error context:(NSManagedObjectContext *)context
{
    self.status = [[NSNumber alloc] initWithUnsignedInteger:AcquireStatus_t_PENDING_ACCEPT_CUSTOMER_SHARE];
    self.shared = [NSDate date];
    self.invalidated = [NSDate date];
    self.sharedTo = taloolFriend;
    return [context save:error];
}


#pragma mark -
#pragma mark - Redeem

- (BOOL) redeemHere:(ttCustomer *)customer
           latitude:(double)latitude
          longitude:(double)longitude
              error:(NSError**)error
            context:(NSManagedObjectContext *)context
{
    BOOL result = NO;
    
    DealAcquireController *dac = [[DealAcquireController alloc] init];
    NSString *redemptionCode = [dac redeem:self forCustomer:customer latitude:latitude longitude:longitude error:error];
    
    if (redemptionCode && !error)
    {
        [self setRedeemed:[NSDate date]];
        self.invalidated = [NSDate date];
        self.redemptionCode = redemptionCode;
        
        result = [context save:error];
    }
    
    return result;
}



#pragma mark -
#pragma mark - Get the Deal Acquires for a Customer

+ (BOOL) getDealAcquires:(ttCustomer *)customer forMerchant:(ttMerchant *)merchant context:(NSManagedObjectContext *)context error:(NSError **)error
{
    BOOL result = NO;
    
    // get the latest deals from the service
    DealAcquireController *dac = [[DealAcquireController alloc] init];
    NSArray *deals = [dac getAcquiredDeals:merchant forCustomer:customer error:error];
    
    if (deals && !error)
    {
        @try {
            // transform the Thrift response into a ttDealAcquire array
            for (DealAcquire_t *d in deals) [ttDealAcquire initWithThrift:d merchant:merchant context:context];
            result = [context save:error];
        }
        @catch (NSException * e) {
            [dac.errorManager handleCoreDataException:e forMethod:@"getAcquiredDeals" entity:@"ttDealAcquire" error:error];
        }
    }
    
    return result;
}

@end
