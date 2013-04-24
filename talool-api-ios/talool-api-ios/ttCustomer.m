//
//  ttCustomer.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/13/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttCustomer.h"
#import "ttSocialAccount.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"
#import "MerchantController.h"
#import "CustomerController.h"


@implementation ttCustomer

+(ttCustomer *)initWithThrift:(Customer_t *)c context:(NSManagedObjectContext *)context
{
    ttCustomer *customer = (ttCustomer *)[NSEntityDescription
                                          insertNewObjectForEntityForName:CUSTOMER_ENTITY_NAME
                                          inManagedObjectContext:context];
    customer.firstName = c.firstName;
    customer.lastName = c.lastName;
    customer.email = c.email;
    customer.sex = [[NSNumber alloc] initWithInt:c.sex];
    customer.customerId = c.customerId;
    
    if (c.socialAccountsIsSet) {
        NSMutableArray *keys = [[NSMutableArray alloc] initWithArray:[c.socialAccounts allKeys]];
        for (int i=0; i<[keys count]; i++) {
            
            NSNumber *key = [[NSNumber alloc] initWithInt:(int)[keys objectAtIndex:i]];
            SocialAccount_t *sat = [c.socialAccounts objectForKey:key];
            ttSocialAccount *sa = [ttSocialAccount initWithThrift:sat context:context];
            [customer addSocialAccountsObject:sa];
        }
    }
    
    return customer;
}

+ (void)clearUsers:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CUSTOMER_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    for (int i=0; i < [mutableFetchResults count]; i++) {
        [context deleteObject:[mutableFetchResults objectAtIndex:i]];
    }
    error = nil;
    if (![context save:&error]) {
        NSLog(@"API: OH SHIT!!!! Failed to save context after clearing users: %@ %@",error, [error userInfo]);
    }
}

+ (ttCustomer *)getLoggedInUser:(NSManagedObjectContext *)context
{
    ttCustomer *user;
    
    // add a predicate for only users with tokens
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"token != nil"];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CUSTOMER_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if ([mutableFetchResults count] == 1) {
        user = [mutableFetchResults objectAtIndex:0];
    } else if ([mutableFetchResults count] > 1) {
        NSLog(@"FAIL: Too many users stored!!!");
        [ttCustomer clearUsers:context];
    }
    
    return user;
}

+ (ttCustomer *)authenticate:(NSString *)email password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError **)err
{
    // clear out any existsing users
    [ttCustomer clearUsers:context];
    
    CustomerController *cController = [[CustomerController alloc] init];
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    NSError *authError = nil;
    
    ttCustomer *user = [cController authenticate:email password:password context:context error:&authError];
    
    if (authError.code < 100) {
        
        [user refresh:context];
        
        NSError *saveError = nil;
        if (![context save:&saveError]) {
            NSLog(@"API: OH SHIT!!!! Failed to save context after authenticating: %@ %@",saveError, [saveError userInfo]);
            [details setValue:@"Failed to save context after authentication." forKey:NSLocalizedDescriptionKey];
            *err = [NSError errorWithDomain:@"save" code:200 userInfo:details];
        }
    } else {
        [details setValue:@"Failed to authenticate user." forKey:NSLocalizedDescriptionKey];
        *err = [NSError errorWithDomain:@"auth" code:200 userInfo:details];
    }
    
    return user;
}

+ (void)logoutUser:(NSManagedObjectContext *)context
{
    ttCustomer *user = [ttCustomer getLoggedInUser:context];
    if (user != nil) {
        [context deleteObject:user];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"API: OH SHIT!!!! Failed to save context after logging out: %@ %@",error, [error userInfo]);
        }
    }
}

+ (void) registerCustomer:(ttCustomer *)customer password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError **)err{
    
    CustomerController *cController = [[CustomerController alloc] init];
    NSError *regError = nil;
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    
    customer = [cController registerUser:customer password:password context:context error:&regError];
    
    if (regError.code < 100) {
        NSError *saveError = nil;
        if (![context save:&saveError]) {
            NSLog(@"API: OH SHIT!!!! Failed to save context after registration: %@ %@",saveError, [saveError userInfo]);
            [details setValue:@"Failed to save context after authentication." forKey:NSLocalizedDescriptionKey];
            *err = [NSError errorWithDomain:@"save" code:200 userInfo:details];
        }
    } else {
        [details setValue:@"Failed to register user." forKey:NSLocalizedDescriptionKey];
        *err = [NSError errorWithDomain:@"reg" code:200 userInfo:details];
    }
}

+ (void) saveCustomer:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)err
{
    CustomerController *cController = [[CustomerController alloc] init];
    NSError *saveError = nil;
    NSMutableDictionary* details = [NSMutableDictionary dictionary];

    [cController save:customer error:&saveError];
    if (saveError.code < 100) {
        NSError *saveError2 = nil;
        if (![context save:&saveError2]) {
            NSLog(@"API: OH SHIT!!!! Failed to save context after save: %@ %@",saveError2, [saveError2 userInfo]);
            [details setValue:@"Failed to save context after save." forKey:NSLocalizedDescriptionKey];
            *err = [NSError errorWithDomain:@"save" code:200 userInfo:details];
        }
    } else {
        // TODO queue up this action to be saved later
        [details setValue:@"Failed to save user." forKey:NSLocalizedDescriptionKey];
        *err = [NSError errorWithDomain:@"save" code:200 userInfo:details];
    }
}

+ (BOOL) doesCustomerExist:(NSString *) email
{
    CustomerController *cController = [[CustomerController alloc] init];
    return [cController userExists:email];
}

+ (NSString *) randomPassword:(int)length
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
    for (int i=0; i<length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

+ (NSString *) nonrandomPassword:(NSString *)seed
{
    return [NSString stringWithFormat:@"talool4%@", seed];
}


+ (ttCustomer *) createCustomer:(NSString *)firstName
                       lastName:(NSString *)lastName
                          email:(NSString *)email
                            sex:(NSNumber *)sex
                  socialAccount:(ttSocialAccount *)socialAccount
                        context:(NSManagedObjectContext *)context
{
    
    ttCustomer *user = (ttCustomer *)[NSEntityDescription
                                      insertNewObjectForEntityForName:CUSTOMER_ENTITY_NAME
                                      inManagedObjectContext:context];
    
    [user setCreated:[NSDate date]];
    [user setFirstName:firstName];
    [user setLastName:lastName];
    [user setEmail:email];
    [user setSex:sex];
    
    
    if (socialAccount != nil){
        [user addSocialAccountsObject:socialAccount];
    }
    
    return user;
}

-(BOOL)isValid:(NSError *__autoreleasing *)error
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    if (self.firstName == nil || self.firstName.length < 2) {
        [details setValue:@"Your first name is invalid" forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"customerValidation" code:200 userInfo:details];
        return NO;
    } else if (self.lastName == nil || self.lastName.length < 2) {
        [details setValue:@"Your last name is invalid" forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"customerValidation" code:200 userInfo:details];
        return NO;
    } else if (self.email == nil || self.email.length < 2) {
        [details setValue:@"Your email is invalid" forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"customerValidation" code:200 userInfo:details];
        return NO;
    }
    return YES;
}

-(Customer_t *)hydrateThriftObject
{
    Customer_t *customer = [[Customer_t alloc] init];
    customer.firstName = self.firstName;
    customer.lastName = self.lastName;
    customer.email = self.email;
    customer.sex = [self.sex integerValue];
    
    customer.customerId = self.customerId;
    
    NSEnumerator *enumerator = [self.socialAccounts objectEnumerator];
    ttSocialAccount *sa;
    SocialAccount_t *sat;
    while (sa = [enumerator nextObject]) {
        sat = [sa hydrateThriftObject];
        [customer.socialAccounts setObject:sat forKey:[[NSNumber alloc] initWithInt:SocialNetwork_t_Facebook]];
    }
    
    return customer;
}

-(NSString *) getFullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

-(ttToken *) getTaloolToken
{
    return (ttToken *)self.token;
}

- (void) refreshMerchants: (NSManagedObjectContext *)context
{
    [self removeMerchants:self.merchants];
    
    CustomerController *cc = [[CustomerController alloc] init];
    NSError *error = [NSError alloc];
    NSMutableArray *merchants = [cc getMerchants:self context:context error:&error];
    NSSet *fMerchants = [[NSSet alloc] initWithArray:merchants];
    
    [self addMerchants:fMerchants];
    
}


- (void) refresh: (NSManagedObjectContext *)context
{
    [self refreshMerchants:context];
}

- (NSArray *) getMyMerchants
{
    NSArray *merchants = [self.merchants allObjects];
    
    return merchants;
}

- (NSArray *) getMyDealsForMerchant:(ttMerchant *)merchant context:(NSManagedObjectContext *)context error:(NSError **)err
{
    
    CustomerController *cc = [[CustomerController alloc] init];
    NSError *error = [NSError alloc];
    NSMutableArray *deals = [cc getAcquiredDeals:merchant forCustomer:self context:context error:&error];
    
    NSError *saveError = nil;
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    if (![context save:&saveError]) {
        NSLog(@"API: OH SHIT!!!! Failed to save context after getMyDealsForMerchant: %@ %@",saveError, [saveError userInfo]);
        [details setValue:@"Failed to save context after getMyDealsForMerchant." forKey:NSLocalizedDescriptionKey];
        *err = [NSError errorWithDomain:@"getMyDealsForMerchant" code:200 userInfo:details];
    }
    
    return deals;
}

@end
