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
#import "ttMerchant.h"
#import "ttDealAcquire.h"
#import "ttDealOffer.h"
#import "TaloolErrorHandler.h"


@implementation ttCustomer

@synthesize favoriteMerchants;

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

+ (void)clearUsers:(NSManagedObjectContext *)context
{
    // Clear all the user's data
    [ttCustomer clearEntity:context entityName:CUSTOMER_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:CUSTOMER_UX_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:MERCHANT_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:MERCHANT_LOCATION_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:LOCATION_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:ADDRESS_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:DEAL_ACQUIRE_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:DEAL_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:GIFT_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:DEAL_OFFER_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:ACTIVITY_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:ACTIVITY_LINK_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:SOCIAL_ACCOUNT_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:SOCIAL_NETWORK_DETAIL_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:FRIEND_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:CATEGORY_ENTITY_NAME];
    [ttCustomer clearEntity:context entityName:TOKEN_ENTITY_NAME];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"API: OH SHIT!!!! Failed to save context after clearing users: %@ %@",error, [error userInfo]);
    }
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
    if ([mutableFetchResults count] == 1) {
        user = [mutableFetchResults objectAtIndex:0];
    } else if ([mutableFetchResults count] > 1) {
        NSLog(@"FAIL: Too many users stored!!!");
        [ttCustomer clearUsers:context];
    }
    
    //NSLog(@"customer token: %@",user.token.token);
    
    return user;
}

+ (ttCustomer *)authenticate:(NSString *)email password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError **)err
{
    // clear out any existsing users
    [ttCustomer clearUsers:context];
    
    CustomerController *cController = [[CustomerController alloc] init];
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    
    ttCustomer *user = [cController authenticate:email password:password context:context error:err];
    if ([*err code] < 100) {
        
        //[user refresh:context];
        
        NSError *saveError;
        if (![context save:&saveError]) {
            NSLog(@"API: OH SHIT!!!! Failed to save context after authenticating: %@ %@",saveError, [saveError userInfo]);
            [details setValue:@"Failed to save context after authentication." forKey:NSLocalizedDescriptionKey];
            *err = [NSError errorWithDomain:@"save" code:200 userInfo:details];
        }
    }
    
    return user;
}

+ (void)logoutUser:(NSManagedObjectContext *)context
{
    ttCustomer *user = [ttCustomer getLoggedInUser:context];
    if (user != nil) {
        // clear out any existsing users
        [ttCustomer clearUsers:context];
    }
}

+ (void) registerCustomer:(ttCustomer *)customer password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError **)err{
    
    CustomerController *cController = [[CustomerController alloc] init];
    NSError *regError;
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    
    customer = [cController registerUser:customer password:password context:context error:&regError];
    
    if (regError.code < 100) {
        NSError *saveError;
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
    customer.birthDate = [self.birthDate timeIntervalSince1970];
    
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

-(ttToken *) getTaloolToken
{
    return (ttToken *)self.token;
}


- (NSArray *) refreshMyDealsForMerchant:(ttMerchant *)merchant context:(NSManagedObjectContext *)context error:(NSError **)err
{
    NSArray *deals;
    
    // get the latest deals from the service
    CustomerController *cc = [[CustomerController alloc] init];
    NSError *error;
    deals = [cc getAcquiredDeals:merchant forCustomer:self context:context error:&error];
    
    // save these deals in the context
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    NSError *saveError;
    if (![context save:&saveError]) {
        NSLog(@"API: OH SHIT!!!! Failed to save context after refreshMyDealsForMerchant: %@ %@",saveError, [saveError userInfo]);
        [details setValue:@"Failed to save context after refreshMyDealsForMerchant." forKey:NSLocalizedDescriptionKey];
        *err = [NSError errorWithDomain:@"save" code:200 userInfo:details];
    }
    
    return deals;
}

/**
 *  Convenience method.
 *  Converts the set of merchants to an array
 **/
- (NSArray *) getMyMerchants
{
    NSArray *merchants = [self.merchants allObjects];
    
    return merchants;
}

/**
 *  Gets the deals for a merchant from the context.
 *  Fails gracefully to a server call if no deals are found in the context.
 **/
- (NSArray *) getMyDealsForMerchant:(ttMerchant *)merchant context:(NSManagedObjectContext *)context error:(NSError **)err
{
    // query the context for these deals
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"ANY deal.merchant.merchantId = %@",merchant.merchantId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:DEAL_ACQUIRE_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSMutableArray *deals = [[context executeFetchRequest:request error:&error] mutableCopy];
    if ([deals count] == 0) {
        // the user shouldn't have a merchant w/o deals
        // assume this is the first time viewing this merchant
        // hit the service to load the deals
        NSError *refreshError = nil;
        deals = (NSMutableArray *)[self refreshMyDealsForMerchant:merchant context:context error:&refreshError];
    }
    
    return deals;
}

/**
 *  Removes the merchants from this user, then calls the service
 *  to reattach the latest set of merchants.
 *  Saves the context and returns nothing.
 **/
- (void) refreshMerchants: (NSManagedObjectContext *)context
{
    
    CustomerController *cc = [[CustomerController alloc] init];
    NSError *error;
    NSArray *tempMerchants = [cc getMerchants:self context:context error:&error];
    
    if ([tempMerchants count]==0 && error.code==ERROR_CODE_NETWORK_DOWN)
    {
        // pull any existing activities from the context
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:MERCHANT_ENTITY_NAME inManagedObjectContext:context];
        [request setEntity:entity];
        NSError *error;
        NSMutableArray *unsortedMerchants = [[context executeFetchRequest:request error:&error] mutableCopy];
        // sort the MERCHANTS
        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
        tempMerchants = [[[NSArray alloc] initWithArray:unsortedMerchants] sortedArrayUsingDescriptors:sortDescriptors];
        NSLog(@"pulled and sorted %d merchants from the context",[tempMerchants count]);
    }
        
    NSSet *fMerchants = [[NSSet alloc] initWithArray:tempMerchants];
    [self removeMerchants:self.merchants];
    [self addMerchants:fMerchants];
    
    // save these merchants in the context
    NSError *saveError;
    if (![context save:&saveError]) {
        NSLog(@"API: OH SHIT!!!! Failed to save context after refreshMerchants: %@ %@",saveError, [saveError userInfo]);
    }
    
}

/**
 *  Call the service for merchant around the user.
 *  Store the merchants in the context and return them.
 *  These merchants are NOT tied to the customer.
 *
 *  TODO: the distanceInMeters param isn't used, so it should be removed
**/
- (NSArray *) getMerchantsByProximity:(int)distanceInMeters
                            longitude:(double)longitude
                             latitude:(double)latitude
                              context:(NSManagedObjectContext *)context
                                error:(NSError **)err
{
    CustomerController *cc = [[CustomerController alloc] init];
    NSError *error;
    NSMutableArray *merchants = [cc getMerchantsWithin:self latitude:latitude longitude:longitude context:context error:&error];
    
    // save these merchants in the context
    NSError *saveError;
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    if (![context save:&saveError]) {
        NSLog(@"API: OH SHIT!!!! Failed to save context after getMerchantsByProximity: %@ %@",saveError, [saveError userInfo]);
        [details setValue:@"Failed to save context after refreshMyDealsForMerchant." forKey:NSLocalizedDescriptionKey];
        *err = [NSError errorWithDomain:@"save" code:200 userInfo:details];
    }
    
    return merchants;
}

/**
 *  Call the service for the user's favorite merchants.
 *  Store the merchants in the context and on the user.
 **/
- (void) refreshFavoriteMerchants:(NSManagedObjectContext *)context
{
    CustomerController *cc = [[CustomerController alloc] init];
    NSError *error;
    favoriteMerchants = [cc getFavoriteMerchants:self context:context error:&error];
    
    // save these merchants in the context
    NSError *saveError;
    if (![context save:&saveError]) {
        NSLog(@"API: OH SHIT!!!! Failed to save context after getFavoriteMerchants: %@ %@",saveError, [saveError userInfo]);
    }
}

- (NSString *)giftToFacebook:(NSString *)dealAcquireId
            facebookId:(NSString *)facebookId
        receipientName:(NSString *)receipientName
                 error:(NSError**)error;
{
    self.ux.hasShared = [[NSNumber alloc] initWithBool:YES];
    CustomerController *cc = [[CustomerController alloc] init];
    return [cc giftToFacebook:self dealAcquireId:dealAcquireId facebookId:facebookId receipientName:receipientName error:error];
}

- (NSString *)giftToEmail:(NSString *)dealAcquireId
              email:(NSString *)email
     receipientName:(NSString *)receipientName
              error:(NSError**)error
{
    self.ux.hasShared = [[NSNumber alloc] initWithBool:YES];
    CustomerController *cc = [[CustomerController alloc] init];
    return [cc giftToEmail:self dealAcquireId:dealAcquireId email:email receipientName:receipientName error:error];
}

- (ttDealAcquire *)acceptGift:(NSString *)giftId
                      context:(NSManagedObjectContext *)context
                        error:(NSError**)error;
{
    CustomerController *cc = [[CustomerController alloc] init];
    return [cc acceptGift:self giftId:giftId context:context error:error];
}

- (BOOL)rejectGift:(NSString *)giftId
             error:(NSError**)error
{
    CustomerController *cc = [[CustomerController alloc] init];
    return [cc rejectGift:self giftId:giftId error:error];
}

- (BOOL) showDealRedemptionInstructions:(ttDealAcquire *)dealAcquire
{
    return (([self.ux.redeemPreviewCount intValue] < 1) &&
            !self.ux.hasRedeemed &&
            ![dealAcquire hasBeenShared] &&
            ![dealAcquire hasBeenShared] &&
            ![dealAcquire hasExpired]
            );
}

- (void) showedDealRedemptionInstructions
{
    self.ux.redeemPreviewCount = [NSNumber numberWithInt:[self.ux.redeemPreviewCount intValue] + 1];
}

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

- (BOOL) purchaseDealOffer:(ttDealOffer *)offer error:(NSError **)err
{
    CustomerController *cc = [[CustomerController alloc] init];
    return [cc purchaseDealOffer:self dealOfferId:offer.dealOfferId error:err];
}

- (NSArray *) getActivities:(NSManagedObjectContext *)context
                      error:(NSError **)err
{
    CustomerController *cc = [[CustomerController alloc] init];
    NSError *error;
    NSArray *activities = [cc getActivities:self context:context error:&error];
    
    if ([activities count]==0 && error.code==ERROR_CODE_NETWORK_DOWN)
    {
        // pull any existing activities from the context
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:ACTIVITY_ENTITY_NAME inManagedObjectContext:context];
        [request setEntity:entity];
        NSError *error;
        NSMutableArray *activitiesTemp = [[context executeFetchRequest:request error:&error] mutableCopy];
        // sort the activities
        NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"activityDate" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortByDate];
        activities = [[[NSArray alloc] initWithArray:activitiesTemp] sortedArrayUsingDescriptors:sortDescriptors];
        NSLog(@"pulled and sorted %d activities from the context",[activities count]);
    }
    
    return activities;
}

- (BOOL)hasDeals:(NSManagedObjectContext *)context
{
    // TODO move this to a service call
    //      there are too many false positives
    
    return YES;
    
    /*
    // query the context for valid deals
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.invalidated = nil"];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:DEAL_ACQUIRE_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSMutableArray *deals = [[context executeFetchRequest:request error:&error] mutableCopy];
    
    return ([deals count]>0);
    */
}

@end
