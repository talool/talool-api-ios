//
//  ttActivityLink.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/26/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolActivityLink.h"

@class ActivityLink_t;

@interface ttActivityLink : TaloolActivityLink

+ (ttActivityLink *)initWithThrift: (ActivityLink_t *)link context:(NSManagedObjectContext *)context;
- (BOOL) isMerchantLink;
- (BOOL) isDealLink;
- (BOOL) isDealOfferLink;
- (BOOL) isGiftLink;
- (BOOL) isCustomerLink;
- (BOOL) isDealAcquireLink;
- (BOOL) isExternalLink;
- (BOOL) isMerchantLocationLink;

@end
