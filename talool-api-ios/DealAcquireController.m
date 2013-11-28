//
//  DealAcquireController.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/27/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "DealAcquireController.h"

#import "ttCustomer.h"
#import "ttToken.h"
#import "ttMerchant.h"
#import "ttDealAcquire.h"

#import "APIErrorManager.h"

#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

#import "CustomerService.h"
#import "Core.h"
#import "Error.h"


@implementation DealAcquireController


#pragma mark -
#pragma mark - Deal Acquires

- (NSString *) redeem:(ttDealAcquire *)dealAcquire
          forCustomer:(ttCustomer *)customer
             latitude:(double)latitude
            longitude:(double)longitude
                error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSString * redemptionCode = nil;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        Location_t *loc = [[Location_t alloc] initWithLongitude:longitude latitude:latitude];
        redemptionCode = [self.service redeem:dealAcquire.dealAcquireId location:loc];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"redeem"
                                                               label:@"success"
                                                               value:nil] build]];
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"redeem" error:error];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"redeem"
                                                               label:@"fail"
                                                               value:nil] build]];
    }
    @finally {
        [self disconnect];
    }
    
    return redemptionCode;
}

- (NSMutableArray *) getAcquiredDeals:(ttMerchant *)merchant forCustomer:(ttCustomer *)customer error:(NSError**)error
{
    NSLog(@"GET DEAL ACQUIRES");
    
    NSMutableArray *deals;
    
    @try {
        // Do the Thrift Merchants
        [self connectWithToken:(ttToken *)customer.token];
        SearchOptions_t *options = [[SearchOptions_t alloc] init];
        [options setMaxResults:1000];
        [options setPage:0];
        [options setAscending:YES];
        [options setSortProperty:@"deal.title"];
        deals = [self.service getDealAcquires:merchant.merchantId searchOptions:options];
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"getAcquiredDeals" error:error];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    return deals;
}


@end
