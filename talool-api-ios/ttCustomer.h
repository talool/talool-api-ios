//
//  ttCustomer.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/13/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "TaloolCustomer.h"
#import "ttToken.h"

@class Customer_t, ttMerchant, ttSocialAccount, ttDealAcquire, ttDealOffer;

@interface ttCustomer : TaloolCustomer

@property (nonatomic, retain) NSArray *favoriteMerchants;

+ (ttCustomer *)initWithThrift: (Customer_t *)customer context:(NSManagedObjectContext *)context;
+ (void)clearUsers:(NSManagedObjectContext *)context;
+ (ttCustomer *)getLoggedInUser:(NSManagedObjectContext *)context;
+ (void)logoutUser:(NSManagedObjectContext *)context;
+ (ttCustomer *)authenticate:(NSString *)email password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError **)err;
+ (void) registerCustomer:(ttCustomer *)customer password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError **)err;
+ (BOOL) doesCustomerExist:(NSString *) email;
+ (NSString *)nonrandomPassword:(NSString *)seed;
+ (NSString *) randomPassword:(int)length;
+ (ttCustomer *) createCustomer:(NSString *)firstName
                       lastName:(NSString *)lastName
                          email:(NSString *)email
                  socialAccount:(ttSocialAccount *)socialAccount
                        context:(NSManagedObjectContext *)context;
+ (BOOL)sendResetPasswordEmail:(NSString *)email
                         error:(NSError**)error;
+ (ttCustomer *)resetPassword:(NSString *)customerId
                     password:(NSString *)password
                         code:(NSString *)resetPasswordCode
                      context:(NSManagedObjectContext *)context
                        error:(NSError**)error;


- (BOOL)isValid:(NSError **)error;
- (BOOL)isFacebookUser;
- (BOOL)hasDeals:(NSManagedObjectContext *)context;
- (Customer_t *)hydrateThriftObject;
- (NSString *)getFullName;
- (ttToken *)getTaloolToken;
- (void)setAsFemale:(BOOL)isFemale;

//- (void) refresh: (NSManagedObjectContext *)context;
- (void) refreshMerchants:(CLLocation *)location context:(NSManagedObjectContext *)context;
- (void) refreshFavoriteMerchants: (NSManagedObjectContext *)context;

- (NSArray *) refreshMyDealsForMerchant:(ttMerchant *)merchant context:(NSManagedObjectContext *)context error:(NSError **)err;
- (NSArray *) getMyMerchants;
- (NSArray *) getMyDealsForMerchant:(ttMerchant *)merchant context:(NSManagedObjectContext *)context error:(NSError **)err;

- (NSString *)giftToFacebook:(NSString *)dealAcquireId
                  facebookId:(NSString *)facebookId
              receipientName:(NSString *)receipientName
                       error:(NSError**)error;
- (NSString *)giftToEmail:(NSString *)dealAcquireId
                    email:(NSString *)email
           receipientName:(NSString *)receipientName
                    error:(NSError**)error;
- (ttDealAcquire *)acceptGift:(NSString *)giftId
                      context:(NSManagedObjectContext *)context
                        error:(NSError**)error;
- (BOOL)rejectGift:(NSString *)giftId
             error:(NSError**)error;

- (BOOL) showDealRedemptionInstructions:(ttDealAcquire *)dealAcquire;
- (void) showedDealRedemptionInstructions;

- (BOOL) purchaseDealOffer:(ttDealOffer *)offer error:(NSError **)err;

- (NSArray *) getActivities:(NSManagedObjectContext *)context
                      error:(NSError **)err;
- (NSArray *) fetchActivities:(NSManagedObjectContext *)context;

@end
