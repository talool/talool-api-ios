//
//  ttActivity.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/26/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolActivity.h"

@class Activity_t, ttCustomer, ttActivityLink;

@interface ttActivity : TaloolActivity

+ (ttActivity *)initWithThrift: (Activity_t *)activity context:(NSManagedObjectContext *)context;
+ (ttActivity *) fetchById:(NSString *)entityId context:(NSManagedObjectContext *)context;
+ (void) refreshActivityForGiftId:(NSString *)entityId context:(NSManagedObjectContext *)context;

- (BOOL) isPurchaseEvent;
- (BOOL) isRedeemEvent;
- (BOOL) isRejectGiftEvent;
- (BOOL) isFacebookReceiveGiftEvent;
- (BOOL) isFacebookSendGiftEvent;
- (BOOL) isEmailReceiveGiftEvent;
- (BOOL) isEmailSendGiftEvent;
- (BOOL) isFriendGiftAcceptEvent;
- (BOOL) isFriendGiftRejectEvent;
- (BOOL) isFriendGiftRedeemEvent;
- (BOOL) isFriendPurchaseEvent;
- (BOOL) isMerchantReachEvent;
- (BOOL) isTaloolReachEvent;
- (BOOL) isWelcomeEvent;
- (BOOL) isUnknownEvent;
- (BOOL) isAd;

- (ttActivityLink *) getLink;
- (BOOL) isActionable;
- (BOOL) isClosed;
- (BOOL) actionTaken:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)err;

+ (NSDictionary *) getActivities:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)error;
+ (NSDictionary *) getMessages:(ttCustomer *)customer
                      latitude:(double)latitude
                     longitude:(double)longitude
                       context:(NSManagedObjectContext *)context
                         error:(NSError **)error;

+ (NSMutableDictionary *) getEmail:(ttCustomer *)customer
                          template:(NSString *)templateId
                            entity:(NSString *)entityId
                             error:(NSError **)error;

+ (NSPredicate *) getGiftPredicate;
+ (NSPredicate *) getMoneyPredicate;
+ (NSPredicate *) getSharePredicate;
+ (NSPredicate *) getReachPredicate;

@end
