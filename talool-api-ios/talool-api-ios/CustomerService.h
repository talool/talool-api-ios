/**
 * Autogenerated by Thrift Compiler (0.9.0)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */

#import <Foundation/Foundation.h>

#import "TProtocol.h"
#import "TApplicationException.h"
#import "TProtocolUtil.h"
#import "TProcessor.h"
#import "TObjective-C.h"

#import "Error.h"
#import "Core.h"
#import "Activity.h"
#import "Payment.h"

@interface CTokenAccess_t : NSObject <NSCoding> {
  Customer_t * __customer;
  NSString * __token;

  BOOL __customer_isset;
  BOOL __token_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=customer, setter=setCustomer:) Customer_t * customer;
@property (nonatomic, retain, getter=token, setter=setToken:) NSString * token;
#endif

- (id) init;
- (id) initWithCustomer: (Customer_t *) customer token: (NSString *) token;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (Customer_t *) customer;
- (void) setCustomer: (Customer_t *) customer;
#endif
- (BOOL) customerIsSet;

#if !__has_feature(objc_arc)
- (NSString *) token;
- (void) setToken: (NSString *) token;
#endif
- (BOOL) tokenIsSet;

@end

@protocol CustomerService_t <NSObject>
- (CTokenAccess_t *) createAccount: (Customer_t *) customer password: (NSString *) password;  // throws ServiceException_t *, TException
- (CTokenAccess_t *) authenticate: (NSString *) email password: (NSString *) password;  // throws ServiceException_t *, TException
- (BOOL) customerEmailExists: (NSString *) email;  // throws ServiceException_t *, TException
- (void) addSocialAccount: (SocialAccount_t *) socialAccount;  // throws ServiceException_t *, TException
- (void) removeSocialAccount: (int) socialNetwork;  // throws ServiceException_t *, TException
- (NSMutableArray *) getMerchantAcquires: (SearchOptions_t *) searchOptions;  // throws ServiceException_t *, TException
- (NSMutableArray *) getMerchantAcquiresWithLocation: (SearchOptions_t *) searchOptions location: (Location_t *) location;  // throws ServiceException_t *, TException
- (NSMutableArray *) getMerchantAcquiresByCategory: (int32_t) categoryId searchOptions: (SearchOptions_t *) searchOptions;  // throws ServiceException_t *, TException
- (NSMutableArray *) getDealAcquires: (NSString *) merchantId searchOptions: (SearchOptions_t *) searchOptions;  // throws ServiceException_t *, TException
- (NSString *) redeem: (NSString *) dealAcquireId location: (Location_t *) location;  // throws ServiceException_t *, TException
- (NSMutableArray *) getDealOffers;  // throws ServiceException_t *, TException
- (void) activateCode: (NSString *) dealOfferid code: (NSString *) code;  // throws ServiceException_t *, TException
- (DealOffer_t *) getDealOffer: (NSString *) dealOfferId;  // throws ServiceException_t *, TException
- (NSMutableArray *) getDealsByDealOfferId: (NSString *) dealOfferId searchOptions: (SearchOptions_t *) searchOptions;  // throws ServiceException_t *, TException
- (void) purchaseDealOffer: (NSString *) dealOfferId;  // throws ServiceException_t *, TException
- (NSMutableArray *) getMerchantsWithin: (Location_t *) location maxMiles: (int32_t) maxMiles searchOptions: (SearchOptions_t *) searchOptions;  // throws ServiceException_t *, TException
- (void) addFavoriteMerchant: (NSString *) merchantId;  // throws ServiceException_t *, TException
- (void) removeFavoriteMerchant: (NSString *) merchantId;  // throws ServiceException_t *, TException
- (NSMutableArray *) getFavoriteMerchants: (SearchOptions_t *) searchOptions;  // throws ServiceException_t *, TException
- (NSMutableArray *) getCategories;  // throws ServiceException_t *, TException
- (NSString *) giftToFacebook: (NSString *) dealAcquireId facebookId: (NSString *) facebookId receipientName: (NSString *) receipientName;  // throws ServiceException_t *, TException
- (NSString *) giftToEmail: (NSString *) dealAcquireId email: (NSString *) email receipientName: (NSString *) receipientName;  // throws ServiceException_t *, TException
- (Gift_t *) getGift: (NSString *) giftId;  // throws ServiceException_t *, TException
- (DealAcquire_t *) acceptGift: (NSString *) giftId;  // throws ServiceException_t *, TException
- (void) rejectGift: (NSString *) giftId;  // throws ServiceException_t *, TException
- (NSMutableArray *) getActivities: (SearchOptions_t *) searchOptions;  // throws ServiceException_t *, TException
- (void) activityAction: (NSString *) activityId;  // throws ServiceException_t *, TException
- (void) sendResetPasswordEmail: (NSString *) email;  // throws TServiceException_t *, TUserException_t *, TNotFoundException_t *, TException
- (void) resetPassword: (NSString *) customerId resetPasswordCode: (NSString *) resetPasswordCode newPassword: (NSString *) newPassword;  // throws TServiceException_t *, TUserException_t *, TNotFoundException_t *, TException
- (TransactionResult_t *) purchaseByCard: (NSString *) dealOfferId paymentDetail: (PaymentDetail_t *) paymentDetail;  // throws TServiceException_t *, TUserException_t *, TNotFoundException_t *, TException
- (TransactionResult_t *) purchaseByCode: (NSString *) dealOfferId paymentCode: (NSString *) paymentCode;  // throws TServiceException_t *, TUserException_t *, TNotFoundException_t *, TException
@end

@interface CustomerService_tClient : NSObject <CustomerService_t> {
  id <TProtocol> inProtocol;
  id <TProtocol> outProtocol;
}
- (id) initWithProtocol: (id <TProtocol>) protocol;
- (id) initWithInProtocol: (id <TProtocol>) inProtocol outProtocol: (id <TProtocol>) outProtocol;
@end

@interface CustomerService_tProcessor : NSObject <TProcessor> {
  id <CustomerService_t> mService;
  NSDictionary * mMethodMap;
}
- (id) initWithCustomerService_t: (id <CustomerService_t>) service;
- (id<CustomerService_t>) service;
@end

@interface CustomerServiceConstants : NSObject {
}
+ (NSString *) CTOKEN_NAME;
@end
