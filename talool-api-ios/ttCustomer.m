//
//  ttCustomer.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/13/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttCustomer.h"
#import "ttSocialAccount.h"
#import "TaloolCustomerUX.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"
#import "MerchantController.h"
#import "CustomerController.h"
#import "DealAcquireController.h"
#import "ttMerchant.h"
#import "ttDealAcquire.h"
#import "ttDealOffer.h"
#import "TaloolErrorHandler.h"
#import "APIErrorManager.h"


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
    
    customer.ux = [NSEntityDescription
                   insertNewObjectForEntityForName:CUSTOMER_UX_ENTITY_NAME
                   inManagedObjectContext:context];
    
    
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



#pragma mark -
#pragma mark Login/Logout (static methods)

+ (BOOL) clearUsers:(NSManagedObjectContext *)context error:(NSError**)error
{
    // Clear all the user's data
    [ttCustomer clearEntity:context entityName:CUSTOMER_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:CUSTOMER_UX_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:MERCHANT_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:MERCHANT_LOCATION_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:DEAL_ACQUIRE_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:DEAL_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:GIFT_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:GIFT_DETAIL_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:DEAL_OFFER_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:DEAL_OFFER_GEO_SUMMARY_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:ACTIVITY_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:ACTIVITY_LINK_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:SOCIAL_ACCOUNT_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:SOCIAL_NETWORK_DETAIL_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:FRIEND_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:CATEGORY_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:TOKEN_ENTITY_NAME];
    
    return [context save:error];
}

+ (void)clearEntity:(NSManagedObjectContext *)context entityName:(NSString *)enitityName
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:enitityName inManagedObjectContext:context];
    [request setEntity:entity];
    NSError *error;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    for (int i=0; i < [mutableFetchResults count]; i++) {
        [context deleteObject:[mutableFetchResults objectAtIndex:i]];
        //NSLog(@"deleted %@",enitityName);
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
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults && !error)
    {
        if ([mutableFetchResults count] == 1) {
            user = [mutableFetchResults objectAtIndex:0];
        } else if ([mutableFetchResults count] > 1) {
            NSLog(@"FAIL: Too many users stored!!!");
            [ttCustomer clearUsers:context error:&error];
        }
    }
    
    return user;
}

+ (BOOL) authenticate:(NSString *)email password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError **)err
{
    BOOL result = NO;
    
    // clear out any existsing users
    [ttCustomer clearUsers:context error:err];
    
    if (!err)
    {
        CustomerController *cc = [[CustomerController alloc] init];
        CTokenAccess_t *token = [cc authenticate:email password:password error:err];
        
        if (token && !err)
        {
            @try {
                // transform the Thrift response into a ttCustomer
                ttToken *ttt = [ttToken initWithThrift:token context:context];
                ttCustomer *customer = (ttCustomer *)ttt.customer;
                customer.token = ttt;
                result = [context save:err];
            }
            @catch (NSException * e) {
                [cc.errorManager handleCoreDataException:e forMethod:@"authenticate" entity:@"ttCustomer" error:err];
            }
        }
    }
    
    return result;
}

+ (BOOL) authenticateFacebook:(NSString *)facebookId
                       facebookToken:(NSString *)facebookToken
                             context:(NSManagedObjectContext *)context
                               error:(NSError**)err
{
    BOOL result = NO;
    
    // clear out any existsing users
    [ttCustomer clearUsers:context error:err];
    
    if (!err)
    {
        CustomerController *cc = [[CustomerController alloc] init];
        CTokenAccess_t *token = [cc authenticateFacebook:facebookId facebookToken:facebookToken error:err];
        if (token && !err)
        {
            @try {
                // transform the Thrift response into a ttCustomer
                ttToken *ttt = [ttToken initWithThrift:token context:context];
                ttCustomer *customer = (ttCustomer *)ttt.customer;
                customer.token = ttt;
                result = [context save:err];
            }
            @catch (NSException * e) {
                [cc.errorManager handleCoreDataException:e forMethod:@"authenticate" entity:@"ttCustomer" error:err];
            }
        }
    }
    
    return result;
}

+ (BOOL) logoutUser:(NSManagedObjectContext *)context error:(NSError**)error
{
    BOOL result = NO;
    ttCustomer *user = [ttCustomer getLoggedInUser:context];
    if (user != nil) {
        // clear out any existsing users
        result = [ttCustomer clearUsers:context error:error];
    }
    return result;
}

+ (BOOL) registerCustomer:(ttCustomer *)customer password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError **)err
{
    BOOL result = NO;
    
    CustomerController *cc = [[CustomerController alloc] init];
    
    // validate data before sending to the server
    if (![customer isValid:err]) return result;

    Customer_t *ct = [customer hydrateThriftObject];
    
    CTokenAccess_t *token = [cc registerUser:ct password:password error:err];
    
    if (token && !err)
    {
        @try {
            // transform the Thrift response into a ttCustomer
            ttToken *ttt = [ttToken initWithThrift:token context:context];
            customer = (ttCustomer *)ttt.customer;
            customer.token = ttt;
            result = [context save:err];
        }
        @catch (NSException * e) {
            [cc.errorManager handleCoreDataException:e forMethod:@"registerUser" entity:@"ttCustomer" error:err];
        }
    }
    
    return result;
}

+ (BOOL) sendResetPasswordEmail:(NSString *)email
                         error:(NSError**)error
{
    CustomerController *cc = [[CustomerController alloc] init];
    return [cc sendResetPasswordEmail:email error:error];
}

+ (BOOL) resetPassword:(NSString *)customerId
              password:(NSString *)password
                  code:(NSString *)resetPasswordCode
               context:(NSManagedObjectContext *)context
                 error:(NSError**)error
{
    BOOL result = NO;
    
    CustomerController *cc = [[CustomerController alloc] init];
    CTokenAccess_t *token = [cc resetPassword:customerId password:password code:resetPasswordCode error:error];
    
    if (token && !error)
    {
        @try {
            // transform the Thrift response into a ttCustomer
            ttToken *ttt = [ttToken initWithThrift:token context:context];
            ttCustomer *customer = (ttCustomer *)ttt.customer;
            customer.token = ttt;
            result = [context save:error];
        }
        @catch (NSException * e) {
            [cc.errorManager handleCoreDataException:e forMethod:@"authenticate" entity:@"ttCustomer" error:error];
        }
    }
    
    return result;
}

+ (BOOL) doesCustomerExist:(NSString *) email
{
    CustomerController *cController = [[CustomerController alloc] init];
    return [cController userExists:email];
}


#pragma mark -
#pragma mark Convenience Methods

- (BOOL)isFacebookUser
{
    NSEnumerator *e = [self.socialAccounts objectEnumerator];
    ttSocialAccount *sa;
    while (sa = [e nextObject]) {
        if ([sa.socialNetwork intValue] == SocialNetwork_t_Facebook) {
            return YES;
        }
    }
    return NO;
}

- (void)setAsFemale:(BOOL)isFemale
{
    if (isFemale)
    {
        self.sex = [NSNumber numberWithInt:Sex_t_F];
    }
    else
    {
        self.sex = [NSNumber numberWithInt:Sex_t_M];
    }
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
    if (self.birthDate)
    {
        customer.birthDate = [self.birthDate timeIntervalSince1970]*1000;
    }
    customer.customerId = self.customerId;
    
    NSEnumerator *enumerator = [self.socialAccounts objectEnumerator];
    NSMutableDictionary *socialAccounts = [[NSMutableDictionary alloc] init];
    ttSocialAccount *sa;
    SocialAccount_t *sat;
    while (sa = [enumerator nextObject]) {
        sat = [sa hydrateThriftObject];
        [socialAccounts setObject:sat forKey:[[NSNumber alloc] initWithInt:SocialNetwork_t_Facebook]];
    }
    [customer setSocialAccounts:socialAccounts];
    
    return customer;
}

-(NSString *) getFullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
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
    [user setSex:[NSNumber numberWithInt:Sex_t_U]];
    
    if (socialAccount != nil){
        [user addSocialAccountsObject:socialAccount];
    }
    
    return user;
}



@end
