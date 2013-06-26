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
        NSURL *url = [NSURL URLWithString:API_URL];
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
        NSURL *url = [NSURL URLWithString:API_URL];
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
    
    // validate data before sending to the server
    if (![customer isValid:error]){
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
        return nil;
    }
    
    return customer;
    
}

- (ttCustomer *)authenticate:(NSString *)email password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError**)error;
{
    ttCustomer *customer;
    CTokenAccess_t *token;

    @try {
        // Do the Thrift Authentication
        [self connect];
        token = [service authenticate:email password:password];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"authenticate" error:error];
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
        return nil;
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

- (NSMutableArray *) getMerchants:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error
{
    // TODO Queue it!
    NSLog(@"FIX IT: GET MERCHANTS: Queue this server call if needed.");
    
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
    // TODO Queue it!
    NSLog(@"FIX IT: GET DEAL ACQUIRES: Queue this server call if needed.");
    
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
    NSString * redemptionCode = nil;
    @try {
        [self connectWithToken:(ttToken *)dealAcquire.customer.token];
        Location_t *loc = [[Location_t alloc] initWithLongitude:longitude latitude:latitude];
        redemptionCode = [service redeem:dealAcquire.dealAcquireId location:loc];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"redeem" error:error];
    }
    @finally {
        [self disconnect];
    }
    return redemptionCode;
}

- (NSMutableArray *) getDealOffers:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error
{
    // TODO Queue it!
    NSLog(@"FIX IT: GET DEAL OFFERS: Queue this server call if needed.");
    
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
    BOOL success;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        [service purchaseDealOffer:dealOfferId];
        success = YES;
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"purchaseDealOffer" error:error];
        success = NO;
    }
    @finally {
        [self disconnect];
    }
    return success;
}

- (NSMutableArray *) getMerchantsWithin:(ttCustomer *)customer latitude:(double) latitude longitude:(double) longitude context:(NSManagedObjectContext *)context error:(NSError**)error
{
    // TODO Queue it!
    NSLog(@"FIX IT: GET MERCHANTS WITH RANGE (%d miles): Queue this server call if needed.", INFINITE_PROXIMITY);
    
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
    // TODO Queue it!
    NSLog(@"FIX IT: GET FAVORITE MERCHANTS: Queue this server call if needed.");
    
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
    // TODO Queue it!
    NSLog(@"FIX IT: GET CATEGORIES: Queue this server call if needed.");
    
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
    // TODO Queue it!
    NSLog(@"FIX IT: GET MERCHANTS BY CATEGORY: Queue this server call if needed.");
    
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
    NSString *giftId;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        giftId = [service giftToFacebook:dealAcquireId facebookId:facebookId receipientName:receipientName];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"giftToFacebook" error:error];
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
     NSString *giftId;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        giftId = [service giftToEmail:dealAcquireId email:email receipientName:receipientName];
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"giftToEmail" error:error];
    }
    @finally {
        [self disconnect];
    }
    
    return giftId;
}

- (NSMutableArray *) getGifts:(ttCustomer *)customer
                      context:(NSManagedObjectContext *)context
                        error:(NSError**)error
{
    // TODO Queue it!
    NSLog(@"FIX IT: GET GIFTS: Queue this server call if needed.");
    
    NSMutableArray *gifts;
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        gifts = [service getGifts];
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
        for (int i=0; i<[gifts count]; i++) {
            Gift_t *td = [gifts objectAtIndex:i];
            ttGift *d = [ttGift initWithThrift:td context:context];
            [gifts setObject:d atIndexedSubscript:i];
        }
    }
    @catch (NSException * e) {
        [errorManager handleCoreDataException:e forMethod:@"getGifts" entity:@"ttGift" error:error];
        return nil;
    }
    
    return gifts;
}

- (BOOL) acceptGift:(ttCustomer *)customer
             giftId:(NSString *)giftId
              error:(NSError**)error
{
    BOOL success;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        [service acceptGift:giftId];
        success = YES;
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"acceptGift" error:error];
        success = NO;
    }
    @finally {
        [self disconnect];
    }
    
    return success;
}

- (BOOL) rejectGift:(ttCustomer *)customer
             giftId:(NSString *)giftId
              error:(NSError**)error
{
    BOOL success;
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        [service rejectGift:giftId];
        success = YES;
    }
    @catch (NSException * e) {
        [errorManager handleServiceException:e forMethod:@"rejectGift" error:error];
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
        [options setSortProperty:@"deal.title"];
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
        [options setAscending:YES];
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

@end
