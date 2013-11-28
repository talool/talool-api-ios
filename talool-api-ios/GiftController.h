//
//  GiftController.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/27/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolThriftController.h"

@class Gift_t, DealAcquire_t, ttCustomer;

@interface GiftController : TaloolThriftController


- (NSString *) giftToFacebook:(ttCustomer *)customer
                dealAcquireId:(NSString *)dealAcquireId
                   facebookId:(NSString *)facebookId
               receipientName:(NSString *)receipientName
                        error:(NSError**)error;
- (NSString *) giftToEmail:(ttCustomer *)customer
             dealAcquireId:(NSString *)dealAcquireId
                     email:(NSString *)email
            receipientName:(NSString *)receipientName
                     error:(NSError**)error;
- (Gift_t *) getGiftById:(NSString *)giftId
                customer:(ttCustomer *)customer
                   error:(NSError**)error;
- (DealAcquire_t *) acceptGift:(ttCustomer *)customer
                        giftId:(NSString *)giftId
                         error:(NSError**)error;
- (BOOL) rejectGift:(ttCustomer *)customer
             giftId:(NSString *)giftId
              error:(NSError**)error;

@end
