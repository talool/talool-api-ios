//
//  GiftController.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/27/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "GiftController.h"

#import "ttCustomer.h"
#import "ttToken.h"
#import "ttGift.h"

#import "APIErrorManager.h"

#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

#import "CustomerService.h"
#import "Core.h"
#import "Error.h"


@implementation GiftController

#pragma mark -
#pragma mark - Gifts

- (NSString *) giftToFacebook:(ttCustomer *)customer
                dealAcquireId:(NSString *)dealAcquireId
                   facebookId:(NSString *)facebookId
               receipientName:(NSString *)receipientName
                        error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSString *giftId;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        giftId = [self.service giftToFacebook:dealAcquireId facebookId:facebookId receipientName:receipientName];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"giftToFacebook"
                                                               label:@"success"
                                                               value:nil] build]];
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"giftToFacebook" error:error];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"giftToFacebook"
                                                               label:@"fail"
                                                               value:nil] build]];
    }
    @finally {
        [self disconnect];
    }
    
    return giftId;
}

- (NSString *) giftToEmail:(ttCustomer *)customer
             dealAcquireId:(NSString *)dealAcquireId
                     email:(NSString *)email
            receipientName:(NSString *)receipientName
                     error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSString *giftId;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        giftId = [self.service giftToEmail:dealAcquireId email:email receipientName:receipientName];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"giftToEmail"
                                                               label:@"success"
                                                               value:nil] build]];
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"giftToEmail" error:error];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"giftToEmail"
                                                               label:@"fail"
                                                               value:nil] build]];
    }
    @finally {
        [self disconnect];
    }
    
    return giftId;
}

- (Gift_t *) getGiftById:(NSString *)giftId
                customer:(ttCustomer *)customer
                   error:(NSError**)error
{
    
    Gift_t *gift;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        gift = [self.service getGift:giftId];
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"getGifts" error:error];
    }
    @finally {
        [self disconnect];
    }
    
    return gift;
}

- (DealAcquire_t *) acceptGift:(ttCustomer *)customer
                        giftId:(NSString *)giftId
                         error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    DealAcquire_t *dt;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        dt = [self.service acceptGift:giftId];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"acceptGift"
                                                               label:@"success"
                                                               value:nil] build]];
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"acceptGift" error:error];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"acceptGift"
                                                               label:@"fail:service_exception"
                                                               value:nil] build]];
    }
    @finally {
        [self disconnect];
    }
    
    return dt;
}

- (BOOL) rejectGift:(ttCustomer *)customer
             giftId:(NSString *)giftId
              error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    BOOL success = NO;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        [self.service rejectGift:giftId];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"rejectGift"
                                                               label:@"success"
                                                               value:nil] build]];
        success = YES;
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"rejectGift" error:error];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"rejectGift"
                                                               label:@"fail"
                                                               value:nil] build]];
    }
    @finally {
        [self disconnect];
    }
    
    return success;
}

@end
