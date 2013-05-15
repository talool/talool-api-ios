//
//  ttDealOffer.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/15/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolDealOffer.h"

@class DealOffer_t;

@interface ttDealOffer : TaloolDealOffer

+ (ttDealOffer *)initWithThrift: (DealOffer_t *)offer context:(NSManagedObjectContext *)context;
- (DealOffer_t *)hydrateThriftObject;

@end
