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

+ (ttDealOffer *)initWithThrift: (DealOffer_t *)offer context:(NSManagedObjectContext *)context;

- (BOOL)getDeals:(ttCustomer *)customer
              context:(NSManagedObjectContext *)context
                error:(NSError **)err;

- (BOOL)activiateCode:(ttCustomer *)customer code:(NSString *)code error:(NSError **)err;

- (BOOL) purchaseByCard:(NSString *)card
               expMonth:(NSString *)expMonth
                expYear:(NSString *)expYear
           securityCode:(NSString *)securityCode
                zipCode:(NSString *)zipCode
           venmoSession:(NSString *)venmoSession
               customer:(ttCustomer *)customer
                  error:(NSError**)error;

- (BOOL) purchaseByCode:(NSString *)paymentCode
               customer:(ttCustomer *)customer
                  error:(NSError**)error;

@end
