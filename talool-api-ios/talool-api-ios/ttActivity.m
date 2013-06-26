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

@implementation ttActivity

+ (ttActivity *)initWithThrift: (Activity_t *)activity context:(NSManagedObjectContext *)context
{
    ttActivity *a = (ttActivity *)[NSEntityDescription
                               insertNewObjectForEntityForName:ACTIVITY_ENTITY_NAME
                               inManagedObjectContext:context];
    
    a.title = activity.title;
    a.subtitle = activity.subtitle;
    a.icon = activity.icon;
    a.link = [ttActivityLink initWithThrift:activity.activityLink context:context];
    a.event = [NSNumber numberWithInt:activity.activityEvent];
    a.activityDate = [NSDate dateWithTimeIntervalSince1970:activity.activityDate/1000];
    
    return a;
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

- (BOOL) isUnknownEvent
{
    return ([self.event intValue] == ActivityEvent_t_UNKNOWN);
}

- (BOOL) isAd
{
    return ([self.event intValue] == ActivityEvent_t_AD);
}

@end
