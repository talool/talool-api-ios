//
//  DealOfferController.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/27/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "TaloolThriftController.h"

@class ttCustomer, ttDealOffer, DealOffer_t;

@interface DealOfferController : TaloolThriftController

- (NSMutableArray *) getDealOfferGeoSummaries:(ttCustomer *)customer
                     withLocation:(CLLocation *)location
                            error:(NSError**)error;
- (DealOffer_t *) getDealOfferById:(NSString *)doId customer:(ttCustomer *)customer error:(NSError**)error;
- (NSMutableArray *) getDealsByDealOfferId:(NSString *)doId customer:(ttCustomer *)customer error:(NSError**)error;

- (BOOL) activateCode:(ttCustomer *)customer offerId:(NSString *)offerId code:(NSString *)code error:(NSError**)error;

- (BOOL) validateCode:(ttCustomer *)customer code:(NSString *)code error:(NSError **)err;

- (BOOL) purchaseByCard:(NSString *)dealOfferId
                   card:(NSString *)card
               expMonth:(NSString *)expMonth
                expYear:(NSString *)expYear
           securityCode:(NSString *)securityCode
                zipCode:(NSString *)zipCode
           venmoSession:(NSString *)venmoSession
               customer:(ttCustomer *)customer
             fundraiser:(NSString *)fundraiser
                  error:(NSError**)error;

- (BOOL) purchaseByCode:(NSString *)dealOfferId
            paymentCode:(NSString *)paymentCode
               customer:(ttCustomer *)customer
             fundraiser:(NSString *)fundraiser
                  error:(NSError**)error;



@end
