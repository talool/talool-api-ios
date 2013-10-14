//
//  ttActivity.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/26/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttActivity.h"
#import "ttActivityLink.h"
#import "Activity.h"
#import "TaloolPersistentStoreCoordinator.h"
#import "CustomerController.h"

@implementation ttActivity

+ (ttActivity *)initWithThrift: (Activity_t *)activity context:(NSManagedObjectContext *)context
{
    
    // see if we have this entity already
    ttActivity *a = [ttActivity fetchById:activity.activityId context:context];
    
    a.activityId = activity.activityId;
    a.title = activity.title;
    a.subtitle = activity.subtitle;
    a.icon = activity.icon;
    a.actionTaken = [NSNumber numberWithBool:activity.actionTaken];
    a.link = [ttActivityLink initWithThrift:activity.activityLink context:context];
    a.event = [NSNumber numberWithInt:activity.activityEvent];
    a.activityDate = [NSDate dateWithTimeIntervalSince1970:activity.activityDate/1000];
    
    return a;
}

+ (ttActivity *) fetchById:(NSString *)entityId context:(NSManagedObjectContext *)context
{
    ttActivity *activity = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.activityId = %@",entityId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:ACTIVITY_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    
    if (fetchedObj == nil || [fetchedObj count] == 0)
    {
        activity = (ttActivity *)[NSEntityDescription
                              insertNewObjectForEntityForName:ACTIVITY_ENTITY_NAME
                              inManagedObjectContext:context];
    }
    else
    {
        activity = [fetchedObj objectAtIndex:0];
    }
    return activity;
}

- (void) actionTaken:(ttCustomer *)customer
{
    CustomerController *cc = [[CustomerController alloc] init];
    NSError *err;
    if ([cc actionTaken:customer actionId:self.activityId error:&err])
    {
        self.actionTaken = [NSNumber numberWithBool:YES];
    }
}

- (BOOL) isClosed
{
    return ([self.actionTaken intValue]==1);
}

- (BOOL) isPurchaseEvent
{
    return ([self.event intValue] == ActivityEvent_t_PURCHASE);
}

- (BOOL) isRedeemEvent
{
    return ([self.event intValue] == ActivityEvent_t_REDEEM);
}

- (BOOL) isRejectGiftEvent
{
    return ([self.event intValue] == ActivityEvent_t_REJECT_GIFT);
}

- (BOOL) isFacebookReceiveGiftEvent
{
    return ([self.event intValue] == ActivityEvent_t_FACEBOOK_RECV_GIFT);
}

- (BOOL) isFacebookSendGiftEvent
{
    return ([self.event intValue] == ActivityEvent_t_FACEBOOK_SEND_GIFT);
}

- (BOOL) isEmailReceiveGiftEvent
{
    return ([self.event intValue] == ActivityEvent_t_EMAIL_RECV_GIFT);
}

- (BOOL) isEmailSendGiftEvent
{
    return ([self.event intValue] == ActivityEvent_t_EMAIL_SEND_GIFT);
}

- (BOOL) isFriendGiftAcceptEvent
{
    return ([self.event intValue] == ActivityEvent_t_FRIEND_GIFT_ACCEPT);
}

- (BOOL) isFriendGiftRejectEvent
{
    return ([self.event intValue] == ActivityEvent_t_FRIEND_GIFT_REJECT);
}

- (BOOL) isFriendGiftRedeemEvent
{
    return ([self.event intValue] == ActivityEvent_t_FRIEND_GIFT_REDEEM);
}

- (BOOL) isFriendPurchaseEvent
{
    return ([self.event intValue] == ActivityEvent_t_FRIEND_PURCHASE_DEAL_OFFER);
}

- (BOOL) isMerchantReachEvent
{
    return ([self.event intValue] == ActivityEvent_t_MERCHANT_REACH);
}

- (BOOL) isTaloolReachEvent
{
    return ([self.event intValue] == ActivityEvent_t_TALOOL_REACH);
}

- (BOOL) isWelcomeEvent
{
    return ([self.event intValue] == ActivityEvent_t_WELCOME);
}

- (BOOL) isUnknownEvent
{
    return ([self.event intValue] == ActivityEvent_t_UNKNOWN);
}

- (BOOL) isAd
{
    return ([self.event intValue] == ActivityEvent_t_AD);
}

+ (NSPredicate *) getGiftPredicate
{
    NSSet *events = [NSSet setWithObjects:
                    [NSNumber numberWithInt:ActivityEvent_t_REJECT_GIFT],
                    [NSNumber numberWithInt:ActivityEvent_t_EMAIL_SEND_GIFT],
                    [NSNumber numberWithInt:ActivityEvent_t_EMAIL_RECV_GIFT],
                    [NSNumber numberWithInt:ActivityEvent_t_FACEBOOK_SEND_GIFT],
                    [NSNumber numberWithInt:ActivityEvent_t_FACEBOOK_RECV_GIFT],
                    nil];
    return [NSPredicate predicateWithFormat:@"SELF.event IN %@", events];
}

+ (NSPredicate *) getMoneyPredicate
{
    NSSet *events = [NSSet setWithObjects:
                     [NSNumber numberWithInt:ActivityEvent_t_PURCHASE],
                     [NSNumber numberWithInt:ActivityEvent_t_REDEEM],
                     nil];
    return [NSPredicate predicateWithFormat:@"SELF.event IN %@", events];
}

+ (NSPredicate *) getSharePredicate
{
    NSSet *events = [NSSet setWithObjects:
                     [NSNumber numberWithInt:ActivityEvent_t_FRIEND_GIFT_ACCEPT],
                     [NSNumber numberWithInt:ActivityEvent_t_FRIEND_GIFT_REJECT],
                     [NSNumber numberWithInt:ActivityEvent_t_FRIEND_GIFT_REDEEM],
                     [NSNumber numberWithInt:ActivityEvent_t_FRIEND_PURCHASE_DEAL_OFFER],
                     nil];
    return [NSPredicate predicateWithFormat:@"SELF.event IN %@", events];
}

+ (NSPredicate *) getReachPredicate
{
    NSSet *events = [NSSet setWithObjects:
                     [NSNumber numberWithInt:ActivityEvent_t_MERCHANT_REACH],
                     [NSNumber numberWithInt:ActivityEvent_t_TALOOL_REACH],
                     [NSNumber numberWithInt:ActivityEvent_t_WELCOME],
                     nil];
    return [NSPredicate predicateWithFormat:@"SELF.event IN %@", events];
}

@end