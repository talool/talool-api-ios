//
//  ttMerchantLoction.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/22/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolMerchantLocation.h"

@class MerchantLocation_t;

@interface ttMerchantLocation : TaloolMerchantLocation

+ (ttMerchantLocation *)initWithThrift: (MerchantLocation_t *)location context:(NSManagedObjectContext *)context;
- (MerchantLocation_t *)hydrateThriftObject;
- (NSString *)getMerchantImageUrl;
- (ttLocation *)getLocation;

@end
