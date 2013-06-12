//
//  CustomerController.h
//  mobile
//
//  Created by Douglas McCuen on 2/21/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ttCustomer, ttMerchant, ttDealAcquire, ttDealAcquire, CustomerService_tClient, ttCategory,APIErrorManager, ttDealOffer;

@interface CustomerController : NSObject {
    CustomerService_tClient *service;
    APIErrorManager *errorManager;
}

// CUSTOMERS
- (ttCustomer *)registerUser:(ttCustomer *)customer password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError**)error;
- (ttCustomer *)authenticate:(NSString *)email password:(NSString *)password context:(NSManagedObjectContext *)context error:(NSError**)error;
- (BOOL)userExists:(NSString *) email;

// MERCHANTS
- (NSMutableArray *) getCategories:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error;
- (NSMutableArray *) getMerchants:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error;
- (NSMutableArray *) getMerchantAcquiresByCategory:(ttCategory *)category customer:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error;
- (NSMutableArray *) getMerchantsWithin:(ttCustomer *)customer latitude:(double) latitude longitude:(double) longitude context:(NSManagedObjectContext *)context error:(NSError**)error;
- (void) addFavoriteMerchant:(ttCustomer *)customer merchantId:(NSString *)merchantId error:(NSError**)error;
- (void) removeFavoriteMerchant:(ttCustomer *)customer merchantId:(NSString *)merchantId error:(NSError**)error;
- (NSMutableArray *) getFavoriteMerchants:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error;


// DEALS AND DEAL OFFERS
- (NSMutableArray *) getAcquiredDeals:(ttMerchant *)merchant forCustomer:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error;
- (NSString *)redeem: (ttDealAcquire *)dealAcquire latitude: (double) latitude longitude: (double) longitude error:(NSError**)error;
- (NSMutableArray *) getDealOffers:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error;
- (void) purchaseDealOffer:(ttCustomer *)customer dealOfferId:(NSString *)dealOfferId error:(NSError**)error;
- (ttDealOffer *) getDealOffer:(NSString *)doId customer:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError**)error;

// GIFTS
- (NSString *) giftToFacebook:(ttCustomer *)customer
          dealAcquireId:(NSString *)dealAcquireId
             facebookId:(NSString *)facebookId
         receipientName:(NSString *)receipientName
                  error:(NSError**)error;
- (NSString *) giftToEmail:(ttCustomer *)customer
       dealAcquireId:(NSString *)dealAcquireId
               email:(NSString *)email
      receipientName:(NSString *)receipientName
               error:(NSError**)error;
- (NSMutableArray *) getGifts:(ttCustomer *)customer
                      context:(NSManagedObjectContext *)context
                        error:(NSError**)error;
- (BOOL) acceptGift:(ttCustomer *)customer
             giftId:(NSString *)giftId
              error:(NSError**)error;
- (BOOL) rejectGift:(ttCustomer *)customer
             giftId:(NSString *)giftId
              error:(NSError**)error;


@end