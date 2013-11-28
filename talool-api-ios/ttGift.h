//
//  ttGift.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/4/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolGift.h"

@class Gift_t, ttCustomer, ttDealAcquire;

@interface ttGift : TaloolGift

+ (ttGift *)initWithThrift: (Gift_t *)gift context:(NSManagedObjectContext *)context;

#pragma mark -
#pragma mark - Convenience methods

- (BOOL) isPending;
- (BOOL) isAccepted;
- (BOOL) isRejected;
- (BOOL) isInvalidated;
- (ttDealAcquire *) getDealAquire:(NSManagedObjectContext *)context;


#pragma mark -
#pragma mark - Gift Management

+ (BOOL) getGiftById:(NSString* )giftId customer:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)err;
+ (NSString *) giftToFacebook:(NSString *)dealAcquireId
               customer:(ttCustomer *)customer
                  facebookId:(NSString *)facebookId
              receipientName:(NSString *)receipientName
                       error:(NSError**)error;
+ (NSString *) giftToEmail:(NSString *)dealAcquireId
            customer:(ttCustomer *)customer
                    email:(NSString *)email
           receipientName:(NSString *)receipientName
                    error:(NSError**)error;
+ (BOOL) acceptGift:(NSString *)giftId
           customer:(ttCustomer *)customer
                      context:(NSManagedObjectContext *)context
                        error:(NSError**)error;
+ (BOOL) rejectGift:(NSString *)giftId
           customer:(ttCustomer *)customer
            context:(NSManagedObjectContext *)context
              error:(NSError**)error;

@end
