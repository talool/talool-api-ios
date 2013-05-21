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
#import "Core.h"
#import "CustomerService.h"
#import "TaloolFrameworkHelper.h"
#import "TaloolPersistentStoreCoordinator.h"


@implementation CustomerController


- (id)init
{
	if ((self = [super init])) {
        //[self connect];
        // TODO DO MORE COOL STUFF HERE
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
    
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    
    @try {
        // Do the Thrift Registration
        [self connect];
        token = [service createAccount:newCustomer password:password];
    }
    @catch (ServiceException_t * se) {
        [details setValue:@"Failed to register user, service failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"registration" code:200 userInfo:details];
        NSLog(@"failed to complete registration cycle: %@",se.description);
        return nil;
    }
    @catch (TApplicationException * tae) {
        [details setValue:@"Failed to register user; app failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"registration" code:200 userInfo:details];
        NSLog(@"failed to complete registration cycle: %@",tae.description);
        return nil;
    }
    @catch (TTransportException * tpe) {
        [details setValue:@"Failed to register user, cuz the server barfed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"registration" code:200 userInfo:details];
        NSLog(@"failed to complete registration cycle: %@",tpe.description);
        return nil;
    }
    @catch (NSException * e) {
        [details setValue:@"Failed to register user... who knows why." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"registration" code:200 userInfo:details];
        NSLog(@"failed to complete registration cycle: %@",e.description);
        return nil;
    }
    @finally {
        [self disconnect];
        
        // delete all TaloolCustomer objects
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:CUSTOMER_ENTITY_NAME inManagedObjectContext:context];
        [request setEntity:entity];
        NSError *error = nil;
        NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
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
        [details setValue:@"Failed to create the customer object." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"post-reg" code:200 userInfo:details];
        NSLog(@"failed to hydrate the user: %@",e.description);
        return nil;
    }
    
    return customer;
    
}

- (ttCustomer *)authenticate:(NSString *)email password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError**)error;
{
    ttCustomer *customer;
    CTokenAccess_t *token;
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    
    @try {
        // Do the Thrift Authentication
        [self connect];
        token = [service authenticate:email password:password];
    }
    @catch (ServiceException_t * se) {
        [details setValue:@"Failed to authenticate user, service failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"login" code:200 userInfo:details];
        NSLog(@"failed to complete login cycle: %@",se.description);
        return nil;
    }
    @catch (TApplicationException * tae) {
        [details setValue:@"Failed to authenticate user; app failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"login" code:200 userInfo:details];
        NSLog(@"failed to complete login cycle: %@",tae.description);
        return nil;
    }
    @catch (TTransportException * tpe) {
        [details setValue:@"Failed to authenticate user, cuz the server barfed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"login" code:200 userInfo:details];
        NSLog(@"failed to complete login cycle: %@",tpe.description);
        return nil;
    }
    @catch (NSException * e) {
        [details setValue:@"Failed to authenticate user... who knows why." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"login" code:200 userInfo:details];
        NSLog(@"failed to complete login cycle: %@",e.description);
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
        [details setValue:@"Failed to create the customer object." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"post-login" code:200 userInfo:details];
        NSLog(@"failed to hydrate the user: %@",e.description);
        return nil;
    }
    
    return customer;
}

- (void)save:(ttCustomer *)customer error:(NSError**)error
{
    // TODO Queue it!
    NSLog(@"FIX IT: SAVE: Queue this server call if needed.");
    
    // Convert the core data obj to a thrift object
    Customer_t *newCustomer = [customer hydrateThriftObject];
    
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    @try {
        // Do the Thrift Save
        [self connectWithToken:(ttToken *)customer.token];
        [service save:newCustomer];
    }
    @catch (ServiceException_t * se) {
        [details setValue:@"Failed to save user, service failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"customer save" code:se.errorCode userInfo:details];
        NSLog(@"failed to complete customer save cycle: %@",se.description);
    }
    @catch (TApplicationException * tae) {
        [details setValue:@"Failed to save user; app failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"customer save" code:500 userInfo:details];
        NSLog(@"failed to complete customer save cycle: %@",tae.description);
    }
    @catch (TTransportException * tpe) {
        [details setValue:@"Failed to save user, cuz the server barfed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"customer save" code:500 userInfo:details];
        NSLog(@"failed to complete customer save cycle: %@",tpe.description);
    }
    @catch (NSException * e) {
        [details setValue:@"Failed to save user... who knows why." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"customer save" code:500 userInfo:details];
        NSLog(@"failed to complete customer save cycle: %@",e.description);
    }
    @finally {
        [self disconnect];
    }
    return;
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
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    
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
    @catch (ServiceException_t * se) {
        [details setValue:@"Failed to getMerchants, service failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getMerchants" code:200 userInfo:details];
        NSLog(@"failed to getMerchants: %@",se.description);
        return nil;
    }
    @catch (TApplicationException * tae) {
        [details setValue:@"Failed to getMerchants; app failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getMerchants" code:200 userInfo:details];
        NSLog(@"failed to getMerchants: %@",tae.description);
        return nil;
    }
    @catch (TTransportException * tpe) {
        [details setValue:@"Failed to getMerchants, cuz the server barfed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getMerchants" code:200 userInfo:details];
        NSLog(@"failed to getMerchants: %@",tpe.description);
        return nil;
    }
    @catch (NSException * e) {
        [details setValue:@"Failed to getMerchants... who knows why." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getMerchants" code:200 userInfo:details];
        NSLog(@"failed to getMerchants: %@",e.description);
        return nil;
    }
    @finally {
        [self disconnect];
    }
    
    @try {
        // transform the Thrift response into a ttMerchant array
        for (int i=0; i<[merchants count]; i++) {
            Merchant_t *tm = [merchants objectAtIndex:i];
            ttMerchant *m = [ttMerchant initWithThrift:tm context:context];
            [merchants setObject:m atIndexedSubscript:i];
        }
    }
    @catch (NSException * e) {
        [details setValue:@"Failed to create the merchant object." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getMerchants" code:200 userInfo:details];
        NSLog(@"failed to hydrate the merchants: %@",e.description);
        return nil;
    }
    
    return merchants;
}

- (NSMutableArray *) getAcquiredDeals:(ttMerchant *)merchant forCustomer:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error
{
    // TODO Queue it!
    NSLog(@"FIX IT: GET DEAL ACQUIRES: Queue this server call if needed.");
    
    NSMutableArray *deals;
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    
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
    @catch (ServiceException_t * se) {
        [details setValue:@"Failed to getAcquiredDeals, service failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getDeals" code:200 userInfo:details];
        NSLog(@"failed to getDeals: %@",se.description);
        return nil;
    }
    @catch (TApplicationException * tae) {
        [details setValue:@"Failed to getAcquiredDeals; app failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getDeals" code:200 userInfo:details];
        NSLog(@"failed to getDeals: %@",tae.description);
        return nil;
    }
    @catch (TTransportException * tpe) {
        [details setValue:@"Failed to getAcquiredDeals, cuz the server barfed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getDeals" code:200 userInfo:details];
        NSLog(@"failed to getDeals: %@",tpe.description);
        return nil;
    }
    @catch (NSException * e) {
        [details setValue:@"Failed to getAcquiredDeals... who knows why." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getDeals" code:200 userInfo:details];
        NSLog(@"failed to getDeals: %@",e.description);
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
        [details setValue:@"Failed to create the ttDealAcquire object." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getAcquiredDeals" code:200 userInfo:details];
        NSLog(@"failed to hydrate the acquired deals: %@",e.description);
        return nil;
    }
    
    return deals;
}

- (void) redeem: (ttDealAcquire *)dealAcquire latitude: (double) latitude longitude: (double) longitude error:(NSError**)error
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    
    @try {
        [self connectWithToken:(ttToken *)dealAcquire.customer.token];
        Location_t *loc = [[Location_t alloc] initWithLongitude:longitude latitude:latitude];
        [service redeem:dealAcquire.dealAcquireId location:loc];
    }
    @catch (ServiceException_t * se) {
        [details setValue:@"Failed to redeem, service failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"redeem" code:200 userInfo:details];
        NSLog(@"failed to redeem: %@",se.description);
    }
    @catch (TApplicationException * tae) {
        [details setValue:@"Failed to redeem; app failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"redeem" code:200 userInfo:details];
        NSLog(@"failed to redeem: %@",tae.description);
    }
    @catch (TTransportException * tpe) {
        [details setValue:@"Failed to redeem, cuz the server barfed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getDeals" code:200 userInfo:details];
        NSLog(@"failed to redeem: %@",tpe.description);
    }
    @catch (NSException * e) {
        [details setValue:@"Failed to redeem... who knows why." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"redeem" code:200 userInfo:details];
        NSLog(@"failed to redeem: %@",e.description);
    }
    @finally {
        [self disconnect];
    }
}

- (NSMutableArray *) getDealOffers:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error
{
    // TODO Queue it!
    NSLog(@"FIX IT: GET DEAL OFFERS: Queue this server call if needed.");
    
    NSMutableArray *offers;
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        offers = [service getDealOffers];
    }
    @catch (ServiceException_t * se) {
        [details setValue:@"Failed to getDealOffers, service failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getDealOffers" code:200 userInfo:details];
        NSLog(@"failed to getDealOffers: %@",se.description);
        return nil;
    }
    @catch (TApplicationException * tae) {
        [details setValue:@"Failed to getDealOffers; app failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getDealOffers" code:200 userInfo:details];
        NSLog(@"failed to getDealOffers: %@",tae.description);
        return nil;
    }
    @catch (TTransportException * tpe) {
        [details setValue:@"Failed to getDealOffers, cuz the server barfed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getDealOffers" code:200 userInfo:details];
        NSLog(@"failed to getDealOffers: %@",tpe.description);
        return nil;
    }
    @catch (NSException * e) {
        [details setValue:@"Failed to getDealOffers... who knows why." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getDealOffers" code:200 userInfo:details];
        NSLog(@"failed to getDealOffers: %@",e.description);
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
        [details setValue:@"Failed to create the ttDealOffer object." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getDealOffers" code:200 userInfo:details];
        NSLog(@"failed to hydrate the deal offers: %@",e.description);
        return nil;
    }
    
    return offers;
}

- (void) purchaseDealOffer:(ttCustomer *)customer dealOfferId:(NSString *)dealOfferId error:(NSError**)error
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        [service purchaseDealOffer:dealOfferId];
    }
    @catch (ServiceException_t * se) {
        [details setValue:@"Failed to purchaseDealOffer, service failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"purchaseDealOffer" code:200 userInfo:details];
        NSLog(@"failed to purchaseDealOffer: %@",se.description);
    }
    @catch (TApplicationException * tae) {
        [details setValue:@"Failed to purchaseDealOffer; app failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"purchaseDealOffer" code:200 userInfo:details];
        NSLog(@"failed to purchaseDealOffer: %@",tae.description);
    }
    @catch (TTransportException * tpe) {
        [details setValue:@"Failed to purchaseDealOffer, cuz the server barfed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"purchaseDealOffer" code:200 userInfo:details];
        NSLog(@"failed to purchaseDealOffer: %@",tpe.description);
    }
    @catch (NSException * e) {
        [details setValue:@"Failed to purchaseDealOffer... who knows why." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"purchaseDealOffer" code:200 userInfo:details];
        NSLog(@"failed to purchaseDealOffer: %@",e.description);
    }
    @finally {
        [self disconnect];
    }
}

- (NSMutableArray *) getMerchantsWithin:(ttCustomer *)customer latitude:(double) latitude longitude:(double) longitude context:(NSManagedObjectContext *)context error:(NSError**)error
{
    // TODO Queue it!
    NSLog(@"FIX IT: GET MERCHANTS WITH RANGE (%d miles): Queue this server call if needed.", INFINITE_PROXIMITY);
    
    NSMutableArray *merchants;
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    
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
    @catch (ServiceException_t * se) {
        [details setValue:@"Failed to getMerchantsWithin, service failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getMerchantsWithin" code:200 userInfo:details];
        NSLog(@"failed to getMerchantsWithin: %@",se.description);
        return nil;
    }
    @catch (TApplicationException * tae) {
        [details setValue:@"Failed to getMerchantsWithin; app failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getMerchantsWithin" code:200 userInfo:details];
        NSLog(@"failed to getMerchantsWithin: %@",tae.description);
        return nil;
    }
    @catch (TTransportException * tpe) {
        [details setValue:@"Failed to getMerchantsWithin, cuz the server barfed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getMerchantsWithin" code:200 userInfo:details];
        NSLog(@"failed to getMerchantsWithin: %@",tpe.description);
        return nil;
    }
    @catch (NSException * e) {
        [details setValue:@"Failed to getMerchantsWithin... who knows why." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getMerchantsWithin" code:200 userInfo:details];
        NSLog(@"failed to getMerchantsWithin: %@",e.description);
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
        [details setValue:@"Failed to create the ttMerchant object." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getMerchantsWithin" code:200 userInfo:details];
        NSLog(@"failed to hydrate the merchants: %@",e.description);
        return nil;
    }
    
    return merchants;
}

- (void) addFavoriteMerchant:(ttCustomer *)customer merchantId:(NSString *)merchantId error:(NSError**)error
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        [service addFavoriteMerchant:merchantId];
    }
    @catch (ServiceException_t * se) {
        [details setValue:@"Failed to addFavoriteMerchant, service failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"addFavoriteMerchant" code:200 userInfo:details];
        NSLog(@"failed to addFavoriteMerchant: %@",se.description);
    }
    @catch (TApplicationException * tae) {
        [details setValue:@"Failed to addFavoriteMerchant; app failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"addFavoriteMerchant" code:200 userInfo:details];
        NSLog(@"failed to addFavoriteMerchant: %@",tae.description);
    }
    @catch (TTransportException * tpe) {
        [details setValue:@"Failed to addFavoriteMerchant, cuz the server barfed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"addFavoriteMerchant" code:200 userInfo:details];
        NSLog(@"failed to addFavoriteMerchant: %@",tpe.description);
    }
    @catch (NSException * e) {
        [details setValue:@"Failed to addFavoriteMerchant... who knows why." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"addFavoriteMerchant" code:200 userInfo:details];
        NSLog(@"failed to addFavoriteMerchant: %@",e.description);
    }
    @finally {
        [self disconnect];
    }
}

- (void) removeFavoriteMerchant:(ttCustomer *)customer merchantId:(NSString *)merchantId error:(NSError**)error
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        [service removeFavoriteMerchant:merchantId];
    }
    @catch (ServiceException_t * se) {
        [details setValue:@"Failed to removeFavoriteMerchant, service failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"removeFavoriteMerchant" code:200 userInfo:details];
        NSLog(@"failed to removeFavoriteMerchant: %@",se.description);
    }
    @catch (TApplicationException * tae) {
        [details setValue:@"Failed to removeFavoriteMerchant; app failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"removeFavoriteMerchant" code:200 userInfo:details];
        NSLog(@"failed to removeFavoriteMerchant: %@",tae.description);
    }
    @catch (TTransportException * tpe) {
        [details setValue:@"Failed to removeFavoriteMerchant, cuz the server barfed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"removeFavoriteMerchant" code:200 userInfo:details];
        NSLog(@"failed to removeFavoriteMerchant: %@",tpe.description);
    }
    @catch (NSException * e) {
        [details setValue:@"Failed to removeFavoriteMerchant... who knows why." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"removeFavoriteMerchant" code:200 userInfo:details];
        NSLog(@"failed to removeFavoriteMerchant: %@",e.description);
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
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        SearchOptions_t *options = [[SearchOptions_t alloc] init];
        [options setMaxResults:1000];
        [options setPage:0];
        [options setAscending:YES];
        [options setSortProperty:@"merchant.name"];
        merchants = [service getFavoriteMerchants:options];
    }
    @catch (ServiceException_t * se) {
        [details setValue:@"Failed to getFavoriteMerchants, service failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getFavoriteMerchants" code:200 userInfo:details];
        NSLog(@"failed to getFavoriteMerchants: %@",se.description);
        return nil;
    }
    @catch (TApplicationException * tae) {
        [details setValue:@"Failed to getFavoriteMerchants; app failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getFavoriteMerchants" code:200 userInfo:details];
        NSLog(@"failed to getFavoriteMerchants: %@",tae.description);
        return nil;
    }
    @catch (TTransportException * tpe) {
        [details setValue:@"Failed to getFavoriteMerchants, cuz the server barfed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getFavoriteMerchants" code:200 userInfo:details];
        NSLog(@"failed to getFavoriteMerchants: %@",tpe.description);
        return nil;
    }
    @catch (NSException * e) {
        [details setValue:@"Failed to getFavoriteMerchants... who knows why." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getFavoriteMerchants" code:200 userInfo:details];
        NSLog(@"failed to getFavoriteMerchants: %@",e.description);
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
        [details setValue:@"Failed to create the ttMerchant object." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getFavoriteMerchants" code:200 userInfo:details];
        NSLog(@"failed to hydrate the merchants: %@",e.description);
        return nil;
    }
    
    return merchants;
}

- (NSMutableArray *) getCategories:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error
{
    // TODO Queue it!
    NSLog(@"FIX IT: GET CATEGORIES: Queue this server call if needed.");
    
    NSMutableArray *categories;
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    
    @try {
        [self connectWithToken:(ttToken *)customer.token];
        categories = [service getCategories];
    }
    @catch (ServiceException_t * se) {
        [details setValue:@"Failed to getCategories, service failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getCategories" code:200 userInfo:details];
        NSLog(@"failed to getCategories: %@",se.description);
        return nil;
    }
    @catch (TApplicationException * tae) {
        [details setValue:@"Failed to getCategories; app failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getCategories" code:200 userInfo:details];
        NSLog(@"failed to getCategories: %@",tae.description);
        return nil;
    }
    @catch (TTransportException * tpe) {
        [details setValue:@"Failed to getCategories, cuz the server barfed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getCategories" code:200 userInfo:details];
        NSLog(@"failed to getCategories: %@",tpe.description);
        return nil;
    }
    @catch (NSException * e) {
        [details setValue:@"Failed to getCategories... who knows why." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getCategories" code:200 userInfo:details];
        NSLog(@"failed to getCategories: %@",e.description);
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
        [details setValue:@"Failed to create the ttCategory object." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getCategories" code:200 userInfo:details];
        NSLog(@"failed to hydrate the categories: %@",e.description);
        return nil;
    }
    
    return categories;
}

- (NSMutableArray *) getMerchantAcquiresByCategory:(ttCategory *)category customer:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error
{
    // TODO Queue it!
    NSLog(@"FIX IT: GET MERCHANTS BY CATEGORY: Queue this server call if needed.");
    
    NSMutableArray *merchants;
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    
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
    @catch (ServiceException_t * se) {
        [details setValue:@"Failed to getMerchantAcquiresByCategory, service failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getMerchantAcquiresByCategory" code:200 userInfo:details];
        NSLog(@"failed to getMerchantAcquiresByCategory: %@",se.description);
        return nil;
    }
    @catch (TApplicationException * tae) {
        [details setValue:@"Failed to getMerchantAcquiresByCategory; app failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getMerchantAcquiresByCategory" code:200 userInfo:details];
        NSLog(@"failed to getMerchantAcquiresByCategory: %@",tae.description);
        return nil;
    }
    @catch (TTransportException * tpe) {
        [details setValue:@"Failed to getMerchantAcquiresByCategory, cuz the server barfed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getMerchantAcquiresByCategory" code:200 userInfo:details];
        NSLog(@"failed to getMerchantAcquiresByCategory: %@",tpe.description);
        return nil;
    }
    @catch (NSException * e) {
        [details setValue:@"Failed to getMerchantAcquiresByCategory... who knows why." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getMerchantAcquiresByCategory" code:200 userInfo:details];
        NSLog(@"failed to getMerchantAcquiresByCategory: %@",e.description);
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
        [details setValue:@"Failed to create the ttMerchant object." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"getMerchantAcquiresByCategory" code:200 userInfo:details];
        NSLog(@"failed to hydrate the merchants: %@",e.description);
        return nil;
    }
    
    return merchants;
}


@end
