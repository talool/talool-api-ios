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
#import "ActivityController.h"
#import <APIErrorManager.h>

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

+ (void) refreshActivityForGiftId:(NSString *)entityId context:(NSManagedObjectContext *)context
{
    ttActivity *activity = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"link.elementId = %@",entityId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:ACTIVITY_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    
    if (fetchedObj != nil || [fetchedObj count] == 1)
    {
        activity = [fetchedObj objectAtIndex:0];
        [context refreshObject:activity mergeChanges:YES];
    }
    
}

+ (NSDictionary *) getActivities:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)error
{
    BOOL result = NO;
    ActivityController *ac = [[ActivityController alloc] init];
    NSArray *activities = [ac getActivities:customer error:error];
    int opencount = 0;
    
    if (activities)
    {
        @try {
            // transform the Thrift response, count open activities, and save the context
            for (Activity_t *at in activities) {
                ttActivity *act = [ttActivity initWithThrift:at context:context];
                if (![act isClosed])
                {
                    opencount++;
                }
            }
            result = [context save:error];
        }
        @catch (NSException * e) {
            [ac.errorManager handleCoreDataException:e forMethod:@"getActivities" entity:@"ttActivity" error:error];
        }
    }
    
    NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
    [response setObject:[NSNumber numberWithBool:result] forKey:@"success"];
    [response setObject:[NSNumber numberWithInt:opencount] forKey:@"openCount"];
    return response;
}

+ (NSDictionary *) getMessages:(ttCustomer *)customer
                      latitude:(double)latitude
                     longitude:(double)longitude
                       context:(NSManagedObjectContext *)context
                         error:(NSError **)error
{
    BOOL result = NO;
    ActivityController *ac = [[ActivityController alloc] init];
    NSArray *activities = [ac getMessages:customer latitude:latitude longitude:longitude error:error];
    int opencount = 0;
    
    if (activities)
    {
        @try {
            // transform the Thrift response, count open activities, and save the context
            for (Activity_t *at in activities) {
                ttActivity *act = [ttActivity initWithThrift:at context:context];
                if (![act isClosed])
                {
                    opencount++;
                }
            }
            result = [context save:error];
        }
        @catch (NSException * e) {
            [ac.errorManager handleCoreDataException:e forMethod:@"getMessages" entity:@"ttActivity" error:error];
        }
    }
    
    NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
    [response setObject:[NSNumber numberWithBool:result] forKey:@"success"];
    [response setObject:[NSNumber numberWithInt:opencount] forKey:@"openCount"];
    return response;
}

+ (NSMutableDictionary *) getEmail:(ttCustomer *)customer
                          template:(NSString *)templateId
                            entity:(NSString *)entityId
                             error:(NSError **)error
{
    ActivityController *ac = [[ActivityController alloc] init];
    return [ac getEmail:customer template:templateId entity:entityId error:error];
}

- (BOOL) actionTaken:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)err
{
    ActivityController *ac = [[ActivityController alloc] init];
    BOOL result = [ac actionTaken:customer actionId:self.activityId error:err];
    if (result)
    {
        self.actionTaken = [NSNumber numberWithBool:YES];
        result = [context save:err];
    }
    return result;
}

- (ttActivityLink *) getLink
{
    return (ttActivityLink *)self.link;
}

- (BOOL) isActionable
{
    ttActivityLink *link = [self getLink];
    return ([link isGiftLink] ||
            [link isEmailLink] ||
            [link isExternalLink]);
}

- (BOOL) isClosed
{
    // these events are always closed
    if (![self isActionable])
    {
        return YES;
    }
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

- (BOOL) isFundraiserSupport
{
    return ([self.event intValue] == ActivityEvent_t_FUNDRAISER_SUPPORT);
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
                     [NSNumber numberWithInt:ActivityEvent_t_FUNDRAISER_SUPPORT],
                     nil];
    return [NSPredicate predicateWithFormat:@"SELF.event IN %@", events];
}

@end
