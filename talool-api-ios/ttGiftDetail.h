//
//  ttGiftDetail.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/19/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolGiftDetail.h"

@class GiftDetail_t;

@interface ttGiftDetail : TaloolGiftDetail

+ (ttGiftDetail *)initWithThrift: (GiftDetail_t *)detail context:(NSManagedObjectContext *)context;

@end
