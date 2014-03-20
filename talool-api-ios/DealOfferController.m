//
//  DealOfferController.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/27/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "DealOfferController.h"

#import "ttCustomer.h"
#import "ttToken.h"
#import "ttDealOffer.h"
#import "ttDealOfferGeoSummary.h"

#import "TaloolFrameworkHelper.h"
#import "APIErrorManager.h"

#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

#import "CustomerService.h"
#import "Core.h"
#import "Payment.h"
#import "Error.h"
#import "Property.h"

@implementation DealOfferController



#pragma mark -
#pragma mark - Purchase a Deal Offer

- (BOOL) purchaseByCard:(NSString *)dealOfferId
                   card:(NSString *)card
               expMonth:(NSString *)expMonth
                expYear:(NSString *)expYear
           securityCode:(NSString *)securityCode
                zipCode:(NSString *)zipCode
           venmoSession:(NSString *)venmoSession
               customer:(ttCustomer *)customer
             fundraiser:(NSString *)fundraiser
                  error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    BOOL result;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        
        
        Card_t *creditcard = [[Card_t alloc] initWithAccountNumber:card
                                                   expirationMonth:expMonth
                                                    expirationYear:expYear
                                                      securityCode:securityCode
                                                           zipCode:zipCode];
        
        NSMutableDictionary *metadata = (NSMutableDictionary *) @{VENMO_SDK_SESSION : venmoSession};
        
        PaymentDetail_t *payment = [[PaymentDetail_t alloc] initWithEncryptedFields:YES card:creditcard paymentMetadata:metadata saveCard:YES];
        
        NSMutableDictionary *paymentProps = [[NSMutableDictionary alloc] init];
        [paymentProps setValue:fundraiser forKey:PropertyConstants.MERCHANT_CODE];

        TransactionResult_t *transactionResult = [self.service purchaseWithCard:dealOfferId paymentDetail:payment paymentProperties:paymentProps];
        if (transactionResult.success)
        {
            
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                                  action:@"purchaseByCard"
                                                                   label:@"success"
                                                                   value:nil] build]];
        }
        else
        {
            
            // handle the error
            [self.errorManager handlePaymentException:nil forMethod:@"purchaseByCard" message:transactionResult.message error:error];
            
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                                  action:@"purchaseByCard"
                                                                   label:@"fail"
                                                                   value:nil] build]];
            
        }
        
        result = transactionResult.success;
    }
    @catch (NSException * e) {
        [self.errorManager handlePaymentException:e forMethod:@"purchaseByCard" message:@"exception" error:error];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"purchaseByCard"
                                                               label:@"fail"
                                                               value:nil] build]];
        result = NO;
    }
    @finally {
        [self disconnect];
    }
    return result;
}

- (BOOL) purchaseByCode:(NSString *)dealOfferId
            paymentCode:(NSString *)paymentCode
               customer:(ttCustomer *)customer
             fundraiser:(NSString *)fundraiser
                  error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    BOOL result;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];

        NSMutableDictionary *paymentProps = [[NSMutableDictionary alloc] init];
        [paymentProps setValue:fundraiser forKey:PropertyConstants.MERCHANT_CODE];
        
        TransactionResult_t *transactionResult = [self.service purchaseWithCode:dealOfferId paymentCode:paymentCode paymentProperties:paymentProps];
        if (transactionResult.success)
        {
            
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                                  action:@"purchaseByCode"
                                                                   label:@"success"
                                                                   value:nil] build]];
        }
        else
        {
            
            // handle the error
            [self.errorManager handlePaymentException:nil forMethod:@"purchaseByCode" message:transactionResult.message error:error];
            
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                                  action:@"purchaseByCode"
                                                                   label:@"fail"
                                                                   value:nil] build]];
            
        }
        
        result = transactionResult.success;
    }
    @catch (NSException * e) {
        [self.errorManager handlePaymentException:e forMethod:@"purchaseByCode" message:@"exception" error:error];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"purchaseByCode"
                                                               label:@"fail"
                                                               value:nil] build]];
        result = NO;
    }
    @finally {
        [self disconnect];
    }
    return result;
}



#pragma mark -
#pragma mark - Activate a Deal Offer

- (int) validateCode:(ttCustomer *)customer offerId:(NSString *)offerId code:(NSString *)code error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    ValidateCodeResponse_t *response;
    int resp;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        
        response = [self.service validateCode:code dealOfferId:offerId];
        
        if (response.valid)
        {
            if ([response.codeType isEqualToString:CoreConstants.MERCHANT_CODE])
            {
                resp = ValidatationResponse_VALID;
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                                      action:@"validateCode"
                                                                       label:@"valid"
                                                                       value:nil] build]];
            }
            else
            {
                resp = ValidatationResponse_ACTIVATED;
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                                      action:@"validateCode"
                                                                       label:@"activated"
                                                                       value:nil] build]];
            }
            
        }
        else
        {
            resp = ValidatationResponse_INVALID;
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                                  action:@"validateCode"
                                                                   label:@"invalid"
                                                                   value:nil] build]];
        }
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"validateCode" error:error];
        resp = ValidatationResponse_ERROR;
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"validateCode"
                                                               label:@"fail"
                                                               value:nil] build]];
    }
    @finally {
        [self disconnect];
    }
    return resp;
}



#pragma mark -
#pragma mark - Get Deal Offers

- (NSMutableArray *) getDealOfferGeoSummaries:(ttCustomer *)customer
                     withLocation:(CLLocation *)location
                            error:(NSError**)error
{
    NSLog(@"GET DEAL OFFER GEO SUMMARIES");
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSMutableArray * result;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        Location_t *loc;
        if (location)
        {
            loc = [[Location_t alloc] initWithLongitude:location.coordinate.longitude latitude:location.coordinate.latitude];
        }
        SearchOptions_t *options = [[SearchOptions_t alloc] init];
        [options setMaxResults:1000];
        [options setPage:0];
        [options setAscending:YES];
        [options setSortProperty:@"distanceInMeters"];
        
        SearchOptions_t *fallbackOptions = [[SearchOptions_t alloc] init];
        [fallbackOptions setMaxResults:1000];
        [fallbackOptions setPage:0];
        [fallbackOptions setAscending:YES];
        [fallbackOptions setSortProperty:@"title"];
        
        DealOfferGeoSummariesResponse_t *response = [self.service getDealOfferGeoSummariesWithin:loc
                                                                                        maxMiles:INFINITE_PROXIMITY
                                                                                   searchOptions:options
                                                                           fallbackSearchOptions:fallbackOptions];
        
        if (response.dealOfferGeoSummariesIsSet)
        {
            result = response.dealOfferGeoSummaries;
        }
        else
        {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                                  action:@"getDealOfferGeoSummaries"
                                                                   label:@"emptyset"
                                                                   value:nil] build]]; 
        }

    }
    @catch (NSException * e)
    {
        [self.errorManager handlePaymentException:e forMethod:@"getDealOfferGeoSummaries" message:@"exception" error:error];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"getDealOfferGeoSummaries"
                                                               label:@"fail"
                                                               value:nil] build]];
    }
    @finally
    {
        [self disconnect];
    }
    
    return result;
}

- (DealOffer_t *) getDealOfferById:(NSString *)doId customer:(ttCustomer *)customer error:(NSError**)error
{
    NSLog(@"GET DEAL OFFER BY ID");
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    DealOffer_t *offer;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];

        offer = [self.service getDealOffer:doId];
        
        if (!offer)
        {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                                  action:@"getDealOfferById"
                                                                   label:@"emptyset"
                                                                   value:nil] build]];
        }
        
    }
    @catch (NSException * e)
    {
        [self.errorManager handlePaymentException:e forMethod:@"getDealOfferGeoSummaries" message:@"exception" error:error];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"getDealOfferById"
                                                               label:@"fail"
                                                               value:nil] build]];
    }
    @finally
    {
        [self disconnect];
    }
    
    return offer;
}



#pragma mark -
#pragma mark - Get Deals for a Deal Offer

- (NSMutableArray *) getDealsByDealOfferId:(NSString *)doId customer:(ttCustomer *)customer error:(NSError**)error
{
    NSLog(@"GET DEALS FOR DEAL OFFER");
    
    NSMutableArray *deals;
    
    @try {
        // Do the Thrift Merchants
        [self connectWithToken:(ttToken *)customer.token];
        SearchOptions_t *options = [[SearchOptions_t alloc] init];
        [options setMaxResults:1000];
        [options setPage:0];
        [options setAscending:YES];
        [options setSortProperty:@"title"];
        deals = [self.service getDealsByDealOfferId:doId searchOptions:options];
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"getDealByDealOfferId" error:error];
    }
    @finally {
        [self disconnect];
    }
    
    return deals;
}



@end
