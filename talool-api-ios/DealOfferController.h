//
//  DealOfferController.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/27/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "TaloolThriftController.h"

@class ttCustomer, ttDealOffer, DealOffer_t, ValidateCodeResponse_t;

@interface DealOfferController : TaloolThriftController

- (NSMutableArray *) getDealOfferGeoSummaries:(ttCustomer *)customer
                     withLocation:(CLLocation *)location
                            error:(NSError**)error;
- (DealOffer_t *) getDealOfferById:(NSString *)doId customer:(ttCustomer *)customer error:(NSError**)error;
- (NSMutableArray *) getDealsByDealOfferId:(NSString *)doId customer:(ttCustomer *)customer error:(NSError**)error;

- (int) validateCode:(ttCustomer *)customer offerId:(NSString *)offerId code:(NSString *)code error:(NSError**)error;

- (BOOL) activateCode:(ttCustomer *)customer offerId:(NSString *)offerId code:(NSString *)code error:(NSError**)error;

- (BOOL) purchaseWithNonce:(NSString *)dealOfferId
                     nonce:(NSString *)nonce
                  customer:(ttCustomer *)customer
                fundraiser:(NSString *)fundraiser
                     error:(NSError**)error;



@end
