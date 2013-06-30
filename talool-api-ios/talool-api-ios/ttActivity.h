//
//  ttActivity.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/26/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolActivity.h"

@class Activity_t;

@interface ttActivity : TaloolActivity

+ (ttActivity *)initWithThrift: (Activity_t *)activity context:(NSManagedObjectContext *)context;
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

@end
