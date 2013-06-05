//
//  ttGift.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/4/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolGift.h"

@class Gift_t;

@interface ttGift : TaloolGift

+ (ttGift *)initWithThrift: (Gift_t *)gift context:(NSManagedObjectContext *)context;
- (Gift_t *)hydrateThriftObject;

@end
