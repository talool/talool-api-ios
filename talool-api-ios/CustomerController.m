//
//  CustomerController.m
//  mobile
//
//  Created by Douglas McCuen on 2/21/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//
#import "THTTPClient.h"
#import "TBinaryProtocol.h"
#import "TTransportException.h"
#import "TaloolHTTPClient.h"
#import "CustomerController.h"
#import "ttCustomer.h"
#import "ttToken.h"
#import "ttMerchant.h"
#import "ttDeal.h"
#import "ttDealAcquire.h"
#import "ttDealOffer.h"
#import "ttCategory.h"
#import "ttGift.h"
#import "Core.h"
#import "Activity.h"
#import "ttActivity.h"
#import "CustomerService.h"
#import "TaloolFrameworkHelper.h"
#import "TaloolPersistentStoreCoordinator.h"
#import "APIErrorManager.h"
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>
#import "Payment.h"
#import "Error.h"


@implementation CustomerController


- (id)init
{
	if ((self = [super init])) {
        errorManager = [[APIErrorManager alloc] init];
	}
	return self;
}

- (void)connect
{
    THTTPClient *transport;
    TBinaryProtocol *protocol;
    @try {
        // Talk to a server via socket, using a binary protocol
        /*
         NOTE: If you try to connect to a server/port that is down,
         the phone will crash with a EXC_BAD_ACCESS when this
         controller is gabage collected.
         */
        NSURL *url = [NSURL URLWithString:[[TaloolFrameworkHelper sharedInstance] getApiUrl]];
        transport = [[THTTPClient alloc] initWithURL:url];
        protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
        service = [[CustomerService_tClient alloc] initWithProtocol:protocol];
    } @catch(NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
}

- (void)connectWithToken:(ttToken *)token
{
    TaloolHTTPClient *transport;
    TBinaryProtocol *protocol;
    @try {
        NSURL *url = [NSURL URLWithString:[[TaloolFrameworkHelper sharedInstance] getApiUrl]];
        transport = [[TaloolHTTPClient alloc] initWithURL:url];
        [[transport getRequest] setValue:token.token forHTTPHeaderField:CustomerServiceConstants.CTOKEN_NAME];
        protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
        service = [[CustomerService_tClient alloc] initWithProtocol:protocol];
    } @catch(NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
}

-(void)disconnect
{
    service = nil;
}

- (ttCustomer *)registerUser:(ttCustomer *)customer password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError**)error
{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    // validate data before sending to the server
    if (![customer isValid:error])
    {
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"registerUser"
                                                               label:@"fail:invalid_user"
                                                               value:nil] build]];
        
        return nil;
    }
    
    // Convert the core data obj to a thrift object
    Customer_t *newCustomer = [customer hydrateThriftObject];
    CTokenAccess_t *token;
    
    @try {
        // Do the Thrift Registration
        [self connect];
        token = [service createAccount:newCustomer password:password];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"registerUser" error:error];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"registerUser"
                                                               label:@"fail:service_exception"
                                                               value:nil] build]];
        return nil;
    }
    @finally {
        [self disconnect];
        
        // delete all TaloolCustomer objects
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:CUSTOMER_ENTITY_NAME inManagedObjectContext:context];
        [request setEntity:entity];
        NSError *cd_error = nil;
        NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&cd_error] mutableCopy];
        if ([mutableFetchResults count] > 0) {
            for (NSManagedObject *extra_user in mutableFetchResults) {
                [context deleteObject:extra_user];
            }
        }
    }
    
    @try {
        // transform the Thrift response into a ttCustomer
        ttToken *ttt = [ttToken initWithThrift:token context:context];
        customer = (ttCustomer *)ttt.customer;
        customer.token = ttt;
        NSError *err = nil;
        [context save:&err];
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"registerUser" entity:@"ttCustomer" error:error];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"registerUser"
                                                               label:@"fail:coredata_exception"
                                                               value:nil] build]];
        return nil;
    }
    
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                          action:@"registerUser"
                                                           label:@"success"
                                                           value:nil] build]];
    
    return customer;
    
}

- (ttCustomer *)authenticate:(NSString *)email password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError**)error;
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    ttCustomer *customer;
    CTokenAccess_t *token;
    
    @try {
        // Do the Thrift Authentication
        [self connect];
        token = [service authenticate:email password:password];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"authenticate" error:error];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"authenticate"
                                                               label:@"fail:service_exception"
                                                               value:nil] build]];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    @try {
        // transform the Thrift response into a ttCustomer
        ttToken *ttt = [ttToken initWithThrift:token context:context];
        customer = (ttCustomer *)ttt.customer;
        customer.token = ttt;
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"authenticate" entity:@"ttCustomer" error:error];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"authenticate"
                                                               label:@"fail:coredata_exception"
                                                               value:nil] build]];
        return nil;
    }

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                          action:@"authenticate"
                                                           label:@"success"
                                                           value:nil] build]];
    
    return customer;
}

- (ttCustomer *)authenticateFacebook:(NSString *)facebookId
                       facebookToken:(NSString *)facebookToken
                             context:(NSManagedObjectContext *)context
                               error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    ttCustomer *customer;
    CTokenAccess_t *token;
    CTokenAccessResponse_t *resp;
    
    @try {
        // Do the Thrift Authentication
        [self connect];
        resp = [service loginFacebook:facebookId facebookAccessToken:facebookToken];
        if (resp.tokenAccessIsSet)
        {
            token = resp.tokenAccess;
        }
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"authenticateFacebook" error:error];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"authenticateFacebook"
                                                               label:@"fail:service_exception"
                                                               value:nil] build]];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    if (token)
    {
        @try {
            // transform the Thrift response into a ttCustomer
            ttToken *ttt = [ttToken initWithThrift:token context:context];
            customer = (ttCustomer *)ttt.customer;
            customer.token = ttt;
        }
        @catch (NSException * e) {
            [errorManager handleCoreDataException:e forMethod:@"authenticate" entity:@"ttCustomer" error:error];
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                                  action:@"authenticate"
                                                                   label:@"fail:coredata_exception"
                                                                   value:nil] build]];
            return nil;
        }
    
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"authenticate"
                                                               label:@"success"
                                                               value:nil] build]];
    }
    
    return customer;
}

- (BOOL)userExists:(NSString *) email
{
    
    BOOL userExists = NO;
    @try {
        [self connect];
        userExists = [service customerEmailExists:email];
    }
    @catch (ServiceException_t * se) {
        NSLog(@"failed to search email: %@",se.description);
    }
    @catch (NSException * e) {
        NSLog(@"failed to search email: %@",e.description);
    }
    @finally {
        [self disconnect];
    }
    return userExists;
}


- (NSMutableArray *) getMerchants:(ttCustomer *)customer
                     withLocation:(CLLocation *)location
                          context:(NSManagedObjectContext *)context
                            error:(NSError**)error
{
    NSLog(@"GET MERCHANTS WITH LOCATION");
    
    NSMutableArray *merchants;
    
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
        [options setSortProperty:@"merchant.name"];
        merchants = [service getMerchantAcquiresWithLocation:options location:loc];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"getMerchantsWithLocation" error:error];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    @try {
        // transform the Thrift response
        for (int i=0; i<[merchants count]; i++) {
            Merchant_t *td = [merchants objectAtIndex:i];
            ttMerchant *d = [ttMerchant initWithThrift:td context:context];
            [merchants setObject:d atIndexedSubscript:i];
        }
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"getMerchantsWithLocation" entity:@"ttMerchant" error:error];
        return nil;
    }
    
    return merchants;
}

- (NSMutableArray *) getMerchants:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error
{
    NSLog(@"GET MERCHANTS");
    
    NSMutableArray *merchants;
    
    @try {
        // Do the Thrift Merchants
        [self connectWithToken:(ttToken *)customer.token];
        SearchOptions_t *options = [[SearchOptions_t alloc] init];
        [options setMaxResults:1000];
        [options setPage:0];
        [options setAscending:YES];
        [options setSortProperty:@"merchant.name"];
        merchants = [service getMerchantAcquires:options];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"getMerchants" error:error];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    //NSLog(@"DEBUG::: got %lu merchants", (unsigned long)[merchants count]);
    @try {
        // transform the Thrift response into a ttMerchant array
        for (int i=0; i<[merchants count]; i++) {
            Merchant_t *tm = [merchants objectAtIndex:i];
            ttMerchant *m = [ttMerchant initWithThrift:tm context:context];
            [merchants setObject:m atIndexedSubscript:i];
        }
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"getMerchants" entity:@"ttMerchant" error:error];
        return nil;
    }
    
    return merchants;
}

- (NSMutableArray *) getAcquiredDeals:(ttMerchant *)merchant forCustomer:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error
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
        deals = [service getDealAcquires:merchant.merchantId searchOptions:options];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"getAcquiredDeals" error:error];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    @try {
        // transform the Thrift response into a ttDealAcquire array
        for (int i=0; i<[deals count]; i++) {
            DealAcquire_t *td = [deals objectAtIndex:i];
            ttDealAcquire *d = [ttDealAcquire initWithThrift:td merchant:merchant context:context];
            //NSLog(@"transformed %@ %@", d.deal.title, d.dealAcquireId);
            [deals setObject:d atIndexedSubscript:i];
        }
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"getAcquiredDeals" entity:@"ttDealAcquire" error:error];
        return nil;
    }
    
    return deals;
}

- (NSString *) redeem: (ttDealAcquire *)dealAcquire latitude: (double) latitude longitude: (double) longitude error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSString * redemptionCode = nil;
    @try {
        [self connectWithToken:(ttToken *)dealAcquire.customer.token];
        Location_t *loc = [[Location_t alloc] initWithLongitude:longitude latitude:latitude];
        redemptionCode = [service redeem:dealAcquire.dealAcquireId location:loc];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"redeem" error:error];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"redeem"
                                                               label:@"fail"
                                                               value:nil] build]];
    }
    @finally {
        [self disconnect];
    }
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                          action:@"redeem"
                                                           label:@"success"
                                                           value:nil] build]];
    
    return redemptionCode;
}

- (NSMutableArray *) getDealOffers:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error
{
    NSLog(@"GET DEAL OFFERS");
    
    NSMutableArray *offers;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        offers = [service getDealOffers];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"getDealOffers" error:error];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    @try {
        // transform the Thrift response
        for (int i=0; i<[offers count]; i++) {
            DealOffer_t *td = [offers objectAtIndex:i];
            ttDealOffer *d = [ttDealOffer initWithThrift:td context:context];
            [offers setObject:d atIndexedSubscript:i];
        }
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"getDealOffers" entity:@"ttDealOffer" error:error];
        return nil;
    }
    
    return offers;
}

- (BOOL) purchaseDealOffer:(ttCustomer *)customer dealOfferId:(NSString *)dealOfferId error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    BOOL success;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        [service purchaseDealOffer:dealOfferId];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                             action:@"purchase"
                                                              label:@"success"
                                                              value:nil] build]];
        
        success = YES;
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"purchaseDealOffer" error:error];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"purchase"
                                                               label:@"fail"
                                                               value:nil] build]];
        success = NO;
    }
    @finally {
        [self disconnect];
    }
    
    return success;
}

- (NSMutableArray *) getMerchantsWithin:(ttCustomer *)customer latitude:(double) latitude longitude:(double) longitude context:(NSManagedObjectContext *)context error:(NSError**)error
{
    NSLog(@"GET MERCHANTS WITH RANGE (%d miles)", INFINITE_PROXIMITY);
    
    NSMutableArray *merchants;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        Location_t *loc = [[Location_t alloc] initWithLongitude:longitude latitude:latitude];
        SearchOptions_t *options = [[SearchOptions_t alloc] init];
        [options setMaxResults:1000];
        [options setPage:0];
        [options setAscending:YES];
        [options setSortProperty:@"merchant.locations.distanceInMeters"];
        merchants = [service getMerchantsWithin:loc maxMiles:INFINITE_PROXIMITY searchOptions:options];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"getMerchantsWithin" error:error];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    //NSLog(@"DEBUG::: got %lu merchants with a range", (unsigned long)[merchants count]);
    @try {
        // transform the Thrift response
        for (int i=0; i<[merchants count]; i++) {
            Merchant_t *td = [merchants objectAtIndex:i];
            //NSLog(@"DEBUG::: merchant name: %@", td.name);
            ttMerchant *d = [ttMerchant initWithThrift:td context:context];
            [merchants setObject:d atIndexedSubscript:i];
        }
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"getMerchantsWithin" entity:@"ttMerchant" error:error];
        return nil;
    }
    
    return merchants;
}

- (void) addFavoriteMerchant:(ttCustomer *)customer merchantId:(NSString *)merchantId error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        [service addFavoriteMerchant:merchantId];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"addFavoriteMerchant" error:error];
    }
    @finally {
        [self disconnect];
    }
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                          action:@"favorite"
                                                           label:@"success"
                                                           value:nil] build]];
}

- (void) removeFavoriteMerchant:(ttCustomer *)customer merchantId:(NSString *)merchantId error:(NSError**)error
{
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        [service removeFavoriteMerchant:merchantId];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"removeFavoriteMerchant" error:error];
    }
    @finally {
        [self disconnect];
    }
}

- (NSMutableArray *) getFavoriteMerchants:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error
{
    NSLog(@"GET FAVORITE MERCHANTS");
    
    NSMutableArray *merchants;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        SearchOptions_t *options = [[SearchOptions_t alloc] init];
        [options setMaxResults:1000];
        [options setPage:0];
        [options setAscending:YES];
        [options setSortProperty:@"merchant.name"];
        merchants = [service getFavoriteMerchants:options];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"getFavoriteMerchants" error:error];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    @try {
        // transform the Thrift response
        for (int i=0; i<[merchants count]; i++) {
            Merchant_t *td = [merchants objectAtIndex:i];
            ttMerchant *d = [ttMerchant initWithThrift:td context:context];
            d.isFav = [NSNumber numberWithBool:YES];
            [merchants setObject:d atIndexedSubscript:i];
        }
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"getFavoriteMerchants" entity:@"ttMerchant" error:error];
        return nil;
    }
    
    return merchants;
}

- (NSMutableArray *) getCategories:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error
{
    NSMutableArray *categories;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        categories = [service getCategories];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"getCategories" error:error];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    @try {
        // transform the Thrift response
        for (int i=0; i<[categories count]; i++) {
            Category_t *td = [categories objectAtIndex:i];
            ttCategory *d = [ttCategory initWithThrift:td context:context];
            [categories setObject:d atIndexedSubscript:i];
        }
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"getCategories" entity:@"ttCategory" error:error];
        return nil;
    }
    
    return categories;
}

- (NSMutableArray *) getMerchantAcquiresByCategory:(ttCategory *)category customer:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error
{
    NSLog(@"GET MERCHANTS BY CATEGORY");
    
    NSMutableArray *merchants;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        SearchOptions_t *options = [[SearchOptions_t alloc] init];
        [options setMaxResults:1000];
        [options setPage:0];
        [options setAscending:YES];
        [options setSortProperty:@"merchant.name"];
        int32_t catId = [category.categoryId intValue];
        merchants = [service getMerchantAcquiresByCategory:catId searchOptions:options];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"getMerchantAcquiresByCategory" error:error];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    @try {
        // transform the Thrift response
        for (int i=0; i<[merchants count]; i++) {
            Merchant_t *td = [merchants objectAtIndex:i];
            ttMerchant *d = [ttMerchant initWithThrift:td context:context];
            d.isFav = [NSNumber numberWithBool:YES];
            [merchants setObject:d atIndexedSubscript:i];
        }
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"getMerchantAcquiresByCategory" entity:@"ttCategory" error:error];
        return nil;
    }
    
    return merchants;
}

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
        giftId = [service giftToFacebook:dealAcquireId facebookId:facebookId receipientName:receipientName];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"giftToFacebook"
                                                               label:@"success"
                                                               value:nil] build]];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"giftToFacebook" error:error];

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
        giftId = [service giftToEmail:dealAcquireId email:email receipientName:receipientName];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"giftToEmail"
                                                               label:@"success"
                                                               value:nil] build]];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"giftToEmail" error:error];

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

- (ttGift *) getGiftById:(NSString *)giftId
                customer:(ttCustomer *)customer
                 context:(NSManagedObjectContext *)context
                   error:(NSError**)error
{
    
    ttGift *gift;
    Gift_t *gift_t;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        gift_t = [service getGift:giftId];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"getGifts" error:error];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    @try {
        // transform the Thrift response
        gift = [ttGift initWithThrift:gift_t context:context];
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"getGiftById" entity:@"ttGift" error:error];
        return nil;
    }
    
    return gift;
}

- (ttDealAcquire *) acceptGift:(ttCustomer *)customer
                        giftId:(NSString *)giftId
                       context:(NSManagedObjectContext *)context
                         error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    ttDealAcquire *deal;
    DealAcquire_t *dt;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        dt = [service acceptGift:giftId];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"acceptGift"
                                                               label:@"success"
                                                               value:nil] build]];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"acceptGift" error:error];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"acceptGift"
                                                               label:@"fail:service_exception"
                                                               value:nil] build]];
    }
    @finally {
        [self disconnect];
    }
    
    @try {
        // transform the Thrift response
        deal = [ttDealAcquire initWithThrift:dt context:context];
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"acceptGift" entity:@"ttGift" error:error];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"acceptGift"
                                                               label:@"fail:coredata_exception"
                                                               value:nil] build]];
        return nil;
    }
    
    return deal;
}

- (BOOL) rejectGift:(ttCustomer *)customer
             giftId:(NSString *)giftId
              error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    BOOL success;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        [service rejectGift:giftId];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"rejectGift"
                                                               label:@"success"
                                                               value:nil] build]];
        success = YES;
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"rejectGift" error:error];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"rejectGift"
                                                               label:@"fail"
                                                               value:nil] build]];
        success = NO;
    }
    @finally {
        [self disconnect];
    }
    
    return success;
}


- (ttDealOffer *) getDealOffer:(NSString *)doId customer:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error
{
    DealOffer_t *dealOffer_t;
    ttDealOffer *dealOffer;
    @try {
        // Do the Thrift Registration
        [self connectWithToken:(ttToken *)customer.token];
        dealOffer_t = [service getDealOffer:doId];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"getDealOffer" error:error];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    @try {
        // transform the Thrift response into a ttDealOffer
        dealOffer = [ttDealOffer initWithThrift:dealOffer_t context:context];
        NSError *err = nil;
        [context save:&err];
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"getDealOffer" entity:@"ttDealOffer" error:error];
        return nil;
    }
    
    return dealOffer;
}

- (NSMutableArray *) getDealsByDealOfferId:(NSString *)doId customer:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error
{
    NSMutableArray *deals;
    
    @try {
        // Do the Thrift Merchants
        [self connectWithToken:(ttToken *)customer.token];
        SearchOptions_t *options = [[SearchOptions_t alloc] init];
        [options setMaxResults:1000];
        [options setPage:0];
        [options setAscending:YES];
        [options setSortProperty:@"title"];
        deals = [service getDealsByDealOfferId:doId searchOptions:options];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"getDealByDealOfferId" error:error];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    @try {
        // transform the Thrift response into a ttDealAcquire array
        for (int i=0; i<[deals count]; i++) {
            Deal_t *td = [deals objectAtIndex:i];
            ttDeal *d = [ttDeal initWithThrift:td merchant:nil context:context];
            [deals setObject:d atIndexedSubscript:i];
        }
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"getDealByDealOfferId" entity:@"ttDeal" error:error];
        return nil;
    }
    
    return deals;
}

- (NSMutableArray *) getActivities:(ttCustomer *)customer
                           context:(NSManagedObjectContext *)context
                             error:(NSError**)error
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
        activities = [service getActivities:options];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"getActivities" error:error];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    //NSLog(@"DEBUG::: ACTIVITY COUNT: %d",[activities count]);
    
    @try {
        // transform the Thrift response into a ttDealAcquire array
        for (int i=0; i<[activities count]; i++) {
            Activity_t *at = [activities objectAtIndex:i];
            ttActivity *tta = [ttActivity initWithThrift:at context:context];
            [activities setObject:tta atIndexedSubscript:i];
        }
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"getActivities" entity:@"ttActivity" error:error];
        return nil;
    }
    
    return activities;
}

-(BOOL) actionTaken:(ttCustomer *)customer actionId:(NSString *)actionId error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    BOOL result;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        [service activityAction:actionId];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"actionTaken"
                                                               label:@"success"
                                                               value:nil] build]];
        result = YES;
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"actionTaken" error:error];

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

- (BOOL) activateCode:(ttCustomer *)customer offerId:(NSString *)offerId code:(NSString *)code error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    BOOL result;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        [service activateCode:offerId code:code];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"activateCode"
                                                               label:@"success"
                                                               value:nil] build]];
        result = YES;
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"activateCode" error:error];
 
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"activateCode"
                                                               label:@"fail"
                                                               value:nil] build]];
        result = NO;
    }
    @finally {
        [self disconnect];
    }
    return result;
}

- (BOOL)sendResetPasswordEmail:(NSString *)email error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    BOOL result;
    
    @try {
        [self connect];
        [service sendResetPasswordEmail:email];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"sendResetPasswordEmail"
                                                               label:@"success"
                                                               value:nil] build]];
        result = YES;
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"sendResetPasswordEmail" error:error];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"sendResetPasswordEmail"
                                                               label:@"fail"
                                                               value:nil] build]];
        result = NO;
    }
    @finally {
        [self disconnect];
    }
    return result;
}

- (ttCustomer *)resetPassword:(NSString *)customerId
                   password:(NSString *)password
                       code:(NSString *)resetPasswordCode
                    context:(NSManagedObjectContext *)context
                      error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    CTokenAccess_t *token;
    ttCustomer *customer;
    
    @try {
        [self connect];
        token = [service resetPassword:customerId resetPasswordCode:resetPasswordCode newPassword:password];
        NSLog(@"token includes name %@ and token %@",token.customer.firstName, token.token);
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"resetPassword" error:error];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"resetPassword"
                                                               label:@"fail"
                                                               value:nil] build]];
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    @try {
        // transform the Thrift response into a ttCustomer
        ttToken *ttt = [ttToken initWithThrift:token context:context];
        customer = (ttCustomer *)ttt.customer;
        customer.token = ttt;
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"authenticate" entity:@"ttCustomer" error:error];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                              action:@"authenticate_after_reset"
                                                               label:@"fail:coredata_exception"
                                                               value:nil] build]];
        return nil;
    }

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                          action:@"resetPassword"
                                                           label:@"success"
                                                           value:nil] build]];
    
    return customer;
}

- (BOOL) purchaseByCard:(NSString *)dealOfferId
                   card:(NSString *)card
               expMonth:(NSString *)expMonth
                expYear:(NSString *)expYear
           securityCode:(NSString *)securityCode
                zipCode:(NSString *)zipCode
           venmoSession:(NSString *)venmoSession
               customer:(ttCustomer *)customer
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

        TransactionResult_t *transactionResult = [service purchaseByCard:dealOfferId paymentDetail:payment];
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
            [errorManager handlePaymentException:nil forMethod:@"purchaseByCard" message:transactionResult.message error:error];

            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                                  action:@"purchaseByCard"
                                                                   label:@"fail"
                                                                   value:nil] build]];
            
        }
        
        result = transactionResult.success;
    }
    @catch (NSException * e) {
        [errorManager handlePaymentException:e forMethod:@"purchaseByCard" message:@"exception" error:error];

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
                  error:(NSError**)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    BOOL result;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        
        TransactionResult_t *transactionResult = [service purchaseByCode:dealOfferId paymentCode:paymentCode];
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
            [errorManager handlePaymentException:nil forMethod:@"purchaseByCode" message:transactionResult.message error:error];

            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"API"
                                                                  action:@"purchaseByCode"
                                                                   label:@"fail"
                                                                   value:nil] build]];
            
        }
        
        result = transactionResult.success;
    }
    @catch (NSException * e) {
        [errorManager handlePaymentException:e forMethod:@"purchaseByCode" message:@"exception" error:error];

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

@end
