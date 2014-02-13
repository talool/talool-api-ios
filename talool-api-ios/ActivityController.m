//
//  ActivityController.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/27/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ActivityController.h"

#import "ttCustomer.h"
#import "ttToken.h"
#import "ttActivity.h"

#import "APIErrorManager.h"

#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

#import "CustomerService.h"
#import "Core.h"
#import "Activity.h"
#import "Error.h"


@implementation ActivityController


#pragma mark -
#pragma mark - Actions

-(BOOL) actionTaken:(ttCustomer *)customer actionId:(NSString *)actionId error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    BOOL result;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        [self.service activityAction:actionId];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"actionTaken"
                                                               label:@"success"
                                                               value:nil] build]];
        result = YES;
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"actionTaken" error:error];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"actionTaken"
                                                               label:@"fail"
                                                               value:nil] build]];
        result = NO;
    }
    @finally {
        [self disconnect];
    }
    return result;
}

- (NSMutableArray *) getActivities:(ttCustomer *)customer error:(NSError**)error
{
    NSMutableArray *activities;
    
    @try {
        // Do the Thrift Merchants
        [self connectWithToken:(ttToken *)customer.token];
        SearchOptions_t *options = [[SearchOptions_t alloc] init];
        [options setMaxResults:1000];
        [options setPage:0];
        [options setAscending:NO];
        [options setSortProperty:@"activityDate"];
        activities = [self.service getActivities:options];
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"getActivities" error:error];
    }
    @finally {
        [self disconnect];
    }
    
    return activities;
}

- (NSMutableArray *) getMessages:(ttCustomer *)customer
                        latitude:(double)latitude
                       longitude:(double)longitude
                           error:(NSError**)error
{
    NSMutableArray *messages;
    
    @try {
        // Do the Thrift Merchants
        [self connectWithToken:(ttToken *)customer.token];
        SearchOptions_t *options = [[SearchOptions_t alloc] init];
        [options setMaxResults:1000];
        [options setPage:0];
        [options setAscending:NO];
        [options setSortProperty:@"activityDate"];
        Location_t *loc = [[Location_t alloc] initWithLongitude:longitude latitude:latitude];
        messages = [self.service getMessages:options location:loc];
    }
    @catch (NSException * e) {
        [self.errorManager handleServiceException:e forMethod:@"getMessages" error:error];
    }
    @finally {
        [self disconnect];
    }
    
    return messages;
}


@end
