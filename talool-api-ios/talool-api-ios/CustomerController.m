//
//  CustomerController.m
//  mobile
//
//  Created by Douglas McCuen on 2/21/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//
#import <THTTPClient.h>
#import <TBinaryProtocol.h>
#import <TTransportException.h>
#import "TaloolHTTPClient.h"
#import "CustomerController.h"
#import "ttCustomer.h"
#import "ttToken.h"
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
        [[transport getRequest] setValue:token.token forHTTPHeaderField:@"ttok"];
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

- (ttCustomer *)registerUser:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error
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
        token = [service createAccount:newCustomer password:customer.password];
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
        NSLog(@"API: completed registration cycle for customerId:%lld and token:%@", token.customer.customerId, token.token);
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
        NSLog(@"API: transformed token for customerId:%d and token:%@", [ttt.customer.customerId intValue], customer.token.token);
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
        NSLog(@"completed login cycle");
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
    // Convert the core data obj to a thrift object
    Customer_t *newCustomer = [customer hydrateThriftObject];
    
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    @try {
        // Do the Thrift Authentication
        [self connectWithToken:(ttToken *)customer.token];
        [service save:newCustomer];
    }
    @catch (ServiceException_t * se) {
        [details setValue:@"Failed to save user, service failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"customer save" code:200 userInfo:details];
        NSLog(@"failed to complete customer save cycle: %@",se.description);
    }
    @catch (TApplicationException * tae) {
        [details setValue:@"Failed to save user; app failed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"customer save" code:200 userInfo:details];
        NSLog(@"failed to complete customer save cycle: %@",tae.description);
    }
    @catch (TTransportException * tpe) {
        [details setValue:@"Failed to save user, cuz the server barfed." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"customer save" code:200 userInfo:details];
        NSLog(@"failed to complete customer save cycle: %@",tpe.description);
    }
    @catch (NSException * e) {
        [details setValue:@"Failed to save user... who knows why." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"customer save" code:200 userInfo:details];
        NSLog(@"failed to complete customer save cycle: %@",e.description);
    }
    @finally {
        NSLog(@"completed save cycle");
        [self disconnect];
    }
    return;
}

- (ttCustomer *)refreshToken:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error
{
    // TODO
    return customer;
}


@end
