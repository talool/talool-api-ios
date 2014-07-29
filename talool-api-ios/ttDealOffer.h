//
//  ttDealOffer.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/15/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolDealOffer.h"

@class DealOffer_t, ttCustomer;

@interface ttDealOffer : TaloolDealOffer

enum {
    ValidatationResponse_ACTIVATED = 0,
    ValidatationResponse_VALID = 1,
    ValidatationResponse_INVALID = 2,
    ValidatationResponse_ERROR = 3
};
typedef int ValidatationResponse;

+ (ttDealOffer *)initWithThrift: (DealOffer_t *)offer context:(NSManagedObjectContext *)context;
+ (ttDealOffer *) fetchById:(NSString *) entityId context:(NSManagedObjectContext *)context;
+ (BOOL) getById:(NSString *)dealOfferId
                 customer:(ttCustomer *)customer
                  context:(NSManagedObjectContext *)context
                    error:(NSError **)error;

- (BOOL)getDeals:(ttCustomer *)customer
              context:(NSManagedObjectContext *)context
                error:(NSError **)err;

- (int)validateCode:(ttCustomer *)customer code:(NSString *)code error:(NSError **)err;

- (BOOL)activiateCode:(ttCustomer *)customer code:(NSString *)code error:(NSError **)err;

- (BOOL) purchaseWithNonce:(NSString *)nonce
                  customer:(ttCustomer *)customer
                fundraiser:(NSString *)fundraiser
                     error:(NSError**)error;

- (BOOL) isFundraiser;



@end
