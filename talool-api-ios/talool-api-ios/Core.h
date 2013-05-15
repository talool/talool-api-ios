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


enum Sex_t {
  Sex_t_M = 0,
  Sex_t_F = 1,
  Sex_t_U = 2
};

enum SocialNetwork_t {
  SocialNetwork_t_Facebook = 0,
  SocialNetwork_t_Twitter = 1,
  SocialNetwork_t_Pinterest = 2
};

enum DealType_t {
  DealType_t_PAID_BOOK = 0,
  DealType_t_FREE_BOOK = 1,
  DealType_t_PAID_DEAL = 2,
  DealType_t_FREE_DEAL = 3
};

typedef int64_t Timestamp;

@interface ServiceException_t : NSException <NSCoding> {
  int32_t __errorCode;
  NSString * __errorDesc;

  BOOL __errorCode_isset;
  BOOL __errorDesc_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=errorCode, setter=setErrorCode:) int32_t errorCode;
@property (nonatomic, retain, getter=errorDesc, setter=setErrorDesc:) NSString * errorDesc;
#endif

- (id) init;
- (id) initWithErrorCode: (int32_t) errorCode errorDesc: (NSString *) errorDesc;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (int32_t) errorCode;
- (void) setErrorCode: (int32_t) errorCode;
#endif
- (BOOL) errorCodeIsSet;

#if !__has_feature(objc_arc)
- (NSString *) errorDesc;
- (void) setErrorDesc: (NSString *) errorDesc;
#endif
- (BOOL) errorDescIsSet;

@end

@interface Location_t : NSObject <NSCoding> {
  double __longitude;
  double __latitude;

  BOOL __longitude_isset;
  BOOL __latitude_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=longitude, setter=setLongitude:) double longitude;
@property (nonatomic, getter=latitude, setter=setLatitude:) double latitude;
#endif

- (id) init;
- (id) initWithLongitude: (double) longitude latitude: (double) latitude;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (double) longitude;
- (void) setLongitude: (double) longitude;
#endif
- (BOOL) longitudeIsSet;

#if !__has_feature(objc_arc)
- (double) latitude;
- (void) setLatitude: (double) latitude;
#endif
- (BOOL) latitudeIsSet;

@end

@interface SocialNetworkDetail_t : NSObject <NSCoding> {
  int __socalNetwork;
  NSString * __name;
  NSString * __website;
  NSString * __apiUrl;

  BOOL __socalNetwork_isset;
  BOOL __name_isset;
  BOOL __website_isset;
  BOOL __apiUrl_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=socalNetwork, setter=setSocalNetwork:) int socalNetwork;
@property (nonatomic, retain, getter=name, setter=setName:) NSString * name;
@property (nonatomic, retain, getter=website, setter=setWebsite:) NSString * website;
@property (nonatomic, retain, getter=apiUrl, setter=setApiUrl:) NSString * apiUrl;
#endif

- (id) init;
- (id) initWithSocalNetwork: (int) socalNetwork name: (NSString *) name website: (NSString *) website apiUrl: (NSString *) apiUrl;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (int) socalNetwork;
- (void) setSocalNetwork: (int) socalNetwork;
#endif
- (BOOL) socalNetworkIsSet;

#if !__has_feature(objc_arc)
- (NSString *) name;
- (void) setName: (NSString *) name;
#endif
- (BOOL) nameIsSet;

#if !__has_feature(objc_arc)
- (NSString *) website;
- (void) setWebsite: (NSString *) website;
#endif
- (BOOL) websiteIsSet;

#if !__has_feature(objc_arc)
- (NSString *) apiUrl;
- (void) setApiUrl: (NSString *) apiUrl;
#endif
- (BOOL) apiUrlIsSet;

@end

@interface SocialAccount_t : NSObject <NSCoding> {
  int __socalNetwork;
  NSString * __loginId;
  Timestamp __created;
  Timestamp __updated;

  BOOL __socalNetwork_isset;
  BOOL __loginId_isset;
  BOOL __created_isset;
  BOOL __updated_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=socalNetwork, setter=setSocalNetwork:) int socalNetwork;
@property (nonatomic, retain, getter=loginId, setter=setLoginId:) NSString * loginId;
@property (nonatomic, getter=created, setter=setCreated:) Timestamp created;
@property (nonatomic, getter=updated, setter=setUpdated:) Timestamp updated;
#endif

- (id) init;
- (id) initWithSocalNetwork: (int) socalNetwork loginId: (NSString *) loginId created: (Timestamp) created updated: (Timestamp) updated;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (int) socalNetwork;
- (void) setSocalNetwork: (int) socalNetwork;
#endif
- (BOOL) socalNetworkIsSet;

#if !__has_feature(objc_arc)
- (NSString *) loginId;
- (void) setLoginId: (NSString *) loginId;
#endif
- (BOOL) loginIdIsSet;

#if !__has_feature(objc_arc)
- (Timestamp) created;
- (void) setCreated: (Timestamp) created;
#endif
- (BOOL) createdIsSet;

#if !__has_feature(objc_arc)
- (Timestamp) updated;
- (void) setUpdated: (Timestamp) updated;
#endif
- (BOOL) updatedIsSet;

@end

@interface Address_t : NSObject <NSCoding> {
  int64_t __addressId;
  NSString * __address1;
  NSString * __address2;
  NSString * __city;
  NSString * __stateProvinceCounty;
  NSString * __zip;
  NSString * __country;

  BOOL __addressId_isset;
  BOOL __address1_isset;
  BOOL __address2_isset;
  BOOL __city_isset;
  BOOL __stateProvinceCounty_isset;
  BOOL __zip_isset;
  BOOL __country_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=addressId, setter=setAddressId:) int64_t addressId;
@property (nonatomic, retain, getter=address1, setter=setAddress1:) NSString * address1;
@property (nonatomic, retain, getter=address2, setter=setAddress2:) NSString * address2;
@property (nonatomic, retain, getter=city, setter=setCity:) NSString * city;
@property (nonatomic, retain, getter=stateProvinceCounty, setter=setStateProvinceCounty:) NSString * stateProvinceCounty;
@property (nonatomic, retain, getter=zip, setter=setZip:) NSString * zip;
@property (nonatomic, retain, getter=country, setter=setCountry:) NSString * country;
#endif

- (id) init;
- (id) initWithAddressId: (int64_t) addressId address1: (NSString *) address1 address2: (NSString *) address2 city: (NSString *) city stateProvinceCounty: (NSString *) stateProvinceCounty zip: (NSString *) zip country: (NSString *) country;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (int64_t) addressId;
- (void) setAddressId: (int64_t) addressId;
#endif
- (BOOL) addressIdIsSet;

#if !__has_feature(objc_arc)
- (NSString *) address1;
- (void) setAddress1: (NSString *) address1;
#endif
- (BOOL) address1IsSet;

#if !__has_feature(objc_arc)
- (NSString *) address2;
- (void) setAddress2: (NSString *) address2;
#endif
- (BOOL) address2IsSet;

#if !__has_feature(objc_arc)
- (NSString *) city;
- (void) setCity: (NSString *) city;
#endif
- (BOOL) cityIsSet;

#if !__has_feature(objc_arc)
- (NSString *) stateProvinceCounty;
- (void) setStateProvinceCounty: (NSString *) stateProvinceCounty;
#endif
- (BOOL) stateProvinceCountyIsSet;

#if !__has_feature(objc_arc)
- (NSString *) zip;
- (void) setZip: (NSString *) zip;
#endif
- (BOOL) zipIsSet;

#if !__has_feature(objc_arc)
- (NSString *) country;
- (void) setCountry: (NSString *) country;
#endif
- (BOOL) countryIsSet;

@end

@interface MerchantLocation_t : NSObject <NSCoding> {
  int64_t __locationId;
  NSString * __name;
  NSString * __email;
  NSString * __websiteUrl;
  NSString * __logoUrl;
  NSString * __phone;
  Address_t * __address;

  BOOL __locationId_isset;
  BOOL __name_isset;
  BOOL __email_isset;
  BOOL __websiteUrl_isset;
  BOOL __logoUrl_isset;
  BOOL __phone_isset;
  BOOL __address_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=locationId, setter=setLocationId:) int64_t locationId;
@property (nonatomic, retain, getter=name, setter=setName:) NSString * name;
@property (nonatomic, retain, getter=email, setter=setEmail:) NSString * email;
@property (nonatomic, retain, getter=websiteUrl, setter=setWebsiteUrl:) NSString * websiteUrl;
@property (nonatomic, retain, getter=logoUrl, setter=setLogoUrl:) NSString * logoUrl;
@property (nonatomic, retain, getter=phone, setter=setPhone:) NSString * phone;
@property (nonatomic, retain, getter=address, setter=setAddress:) Address_t * address;
#endif

- (id) init;
- (id) initWithLocationId: (int64_t) locationId name: (NSString *) name email: (NSString *) email websiteUrl: (NSString *) websiteUrl logoUrl: (NSString *) logoUrl phone: (NSString *) phone address: (Address_t *) address;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (int64_t) locationId;
- (void) setLocationId: (int64_t) locationId;
#endif
- (BOOL) locationIdIsSet;

#if !__has_feature(objc_arc)
- (NSString *) name;
- (void) setName: (NSString *) name;
#endif
- (BOOL) nameIsSet;

#if !__has_feature(objc_arc)
- (NSString *) email;
- (void) setEmail: (NSString *) email;
#endif
- (BOOL) emailIsSet;

#if !__has_feature(objc_arc)
- (NSString *) websiteUrl;
- (void) setWebsiteUrl: (NSString *) websiteUrl;
#endif
- (BOOL) websiteUrlIsSet;

#if !__has_feature(objc_arc)
- (NSString *) logoUrl;
- (void) setLogoUrl: (NSString *) logoUrl;
#endif
- (BOOL) logoUrlIsSet;

#if !__has_feature(objc_arc)
- (NSString *) phone;
- (void) setPhone: (NSString *) phone;
#endif
- (BOOL) phoneIsSet;

#if !__has_feature(objc_arc)
- (Address_t *) address;
- (void) setAddress: (Address_t *) address;
#endif
- (BOOL) addressIsSet;

@end

@interface Customer_t : NSObject <NSCoding> {
  NSString * __customerId;
  NSString * __firstName;
  NSString * __lastName;
  NSString * __email;
  int __sex;
  NSMutableDictionary * __socialAccounts;
  Timestamp __created;
  Timestamp __updated;

  BOOL __customerId_isset;
  BOOL __firstName_isset;
  BOOL __lastName_isset;
  BOOL __email_isset;
  BOOL __sex_isset;
  BOOL __socialAccounts_isset;
  BOOL __created_isset;
  BOOL __updated_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=customerId, setter=setCustomerId:) NSString * customerId;
@property (nonatomic, retain, getter=firstName, setter=setFirstName:) NSString * firstName;
@property (nonatomic, retain, getter=lastName, setter=setLastName:) NSString * lastName;
@property (nonatomic, retain, getter=email, setter=setEmail:) NSString * email;
@property (nonatomic, getter=sex, setter=setSex:) int sex;
@property (nonatomic, retain, getter=socialAccounts, setter=setSocialAccounts:) NSMutableDictionary * socialAccounts;
@property (nonatomic, getter=created, setter=setCreated:) Timestamp created;
@property (nonatomic, getter=updated, setter=setUpdated:) Timestamp updated;
#endif

- (id) init;
- (id) initWithCustomerId: (NSString *) customerId firstName: (NSString *) firstName lastName: (NSString *) lastName email: (NSString *) email sex: (int) sex socialAccounts: (NSMutableDictionary *) socialAccounts created: (Timestamp) created updated: (Timestamp) updated;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (NSString *) customerId;
- (void) setCustomerId: (NSString *) customerId;
#endif
- (BOOL) customerIdIsSet;

#if !__has_feature(objc_arc)
- (NSString *) firstName;
- (void) setFirstName: (NSString *) firstName;
#endif
- (BOOL) firstNameIsSet;

#if !__has_feature(objc_arc)
- (NSString *) lastName;
- (void) setLastName: (NSString *) lastName;
#endif
- (BOOL) lastNameIsSet;

#if !__has_feature(objc_arc)
- (NSString *) email;
- (void) setEmail: (NSString *) email;
#endif
- (BOOL) emailIsSet;

#if !__has_feature(objc_arc)
- (int) sex;
- (void) setSex: (int) sex;
#endif
- (BOOL) sexIsSet;

#if !__has_feature(objc_arc)
- (NSMutableDictionary *) socialAccounts;
- (void) setSocialAccounts: (NSMutableDictionary *) socialAccounts;
#endif
- (BOOL) socialAccountsIsSet;

#if !__has_feature(objc_arc)
- (Timestamp) created;
- (void) setCreated: (Timestamp) created;
#endif
- (BOOL) createdIsSet;

#if !__has_feature(objc_arc)
- (Timestamp) updated;
- (void) setUpdated: (Timestamp) updated;
#endif
- (BOOL) updatedIsSet;

@end

@interface Token_t : NSObject <NSCoding> {
  NSString * __accountId;
  NSString * __email;
  int64_t __expires;

  BOOL __accountId_isset;
  BOOL __email_isset;
  BOOL __expires_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=accountId, setter=setAccountId:) NSString * accountId;
@property (nonatomic, retain, getter=email, setter=setEmail:) NSString * email;
@property (nonatomic, getter=expires, setter=setExpires:) int64_t expires;
#endif

- (id) init;
- (id) initWithAccountId: (NSString *) accountId email: (NSString *) email expires: (int64_t) expires;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (NSString *) accountId;
- (void) setAccountId: (NSString *) accountId;
#endif
- (BOOL) accountIdIsSet;

#if !__has_feature(objc_arc)
- (NSString *) email;
- (void) setEmail: (NSString *) email;
#endif
- (BOOL) emailIsSet;

#if !__has_feature(objc_arc)
- (int64_t) expires;
- (void) setExpires: (int64_t) expires;
#endif
- (BOOL) expiresIsSet;

@end

@interface Merchant_t : NSObject <NSCoding> {
  NSString * __merchantId;
  NSString * __name;
  NSMutableArray * __locations;

  BOOL __merchantId_isset;
  BOOL __name_isset;
  BOOL __locations_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=merchantId, setter=setMerchantId:) NSString * merchantId;
@property (nonatomic, retain, getter=name, setter=setName:) NSString * name;
@property (nonatomic, retain, getter=locations, setter=setLocations:) NSMutableArray * locations;
#endif

- (id) init;
- (id) initWithMerchantId: (NSString *) merchantId name: (NSString *) name locations: (NSMutableArray *) locations;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (NSString *) merchantId;
- (void) setMerchantId: (NSString *) merchantId;
#endif
- (BOOL) merchantIdIsSet;

#if !__has_feature(objc_arc)
- (NSString *) name;
- (void) setName: (NSString *) name;
#endif
- (BOOL) nameIsSet;

#if !__has_feature(objc_arc)
- (NSMutableArray *) locations;
- (void) setLocations: (NSMutableArray *) locations;
#endif
- (BOOL) locationsIsSet;

@end

@interface Deal_t : NSObject <NSCoding> {
  NSString * __dealId;
  Merchant_t * __merchant;
  NSString * __title;
  NSString * __summary;
  NSString * __details;
  NSString * __code;
  NSString * __imageUrl;
  Timestamp __expires;
  Timestamp __created;
  Timestamp __updated;

  BOOL __dealId_isset;
  BOOL __merchant_isset;
  BOOL __title_isset;
  BOOL __summary_isset;
  BOOL __details_isset;
  BOOL __code_isset;
  BOOL __imageUrl_isset;
  BOOL __expires_isset;
  BOOL __created_isset;
  BOOL __updated_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=dealId, setter=setDealId:) NSString * dealId;
@property (nonatomic, retain, getter=merchant, setter=setMerchant:) Merchant_t * merchant;
@property (nonatomic, retain, getter=title, setter=setTitle:) NSString * title;
@property (nonatomic, retain, getter=summary, setter=setSummary:) NSString * summary;
@property (nonatomic, retain, getter=details, setter=setDetails:) NSString * details;
@property (nonatomic, retain, getter=code, setter=setCode:) NSString * code;
@property (nonatomic, retain, getter=imageUrl, setter=setImageUrl:) NSString * imageUrl;
@property (nonatomic, getter=expires, setter=setExpires:) Timestamp expires;
@property (nonatomic, getter=created, setter=setCreated:) Timestamp created;
@property (nonatomic, getter=updated, setter=setUpdated:) Timestamp updated;
#endif

- (id) init;
- (id) initWithDealId: (NSString *) dealId merchant: (Merchant_t *) merchant title: (NSString *) title summary: (NSString *) summary details: (NSString *) details code: (NSString *) code imageUrl: (NSString *) imageUrl expires: (Timestamp) expires created: (Timestamp) created updated: (Timestamp) updated;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (NSString *) dealId;
- (void) setDealId: (NSString *) dealId;
#endif
- (BOOL) dealIdIsSet;

#if !__has_feature(objc_arc)
- (Merchant_t *) merchant;
- (void) setMerchant: (Merchant_t *) merchant;
#endif
- (BOOL) merchantIsSet;

#if !__has_feature(objc_arc)
- (NSString *) title;
- (void) setTitle: (NSString *) title;
#endif
- (BOOL) titleIsSet;

#if !__has_feature(objc_arc)
- (NSString *) summary;
- (void) setSummary: (NSString *) summary;
#endif
- (BOOL) summaryIsSet;

#if !__has_feature(objc_arc)
- (NSString *) details;
- (void) setDetails: (NSString *) details;
#endif
- (BOOL) detailsIsSet;

#if !__has_feature(objc_arc)
- (NSString *) code;
- (void) setCode: (NSString *) code;
#endif
- (BOOL) codeIsSet;

#if !__has_feature(objc_arc)
- (NSString *) imageUrl;
- (void) setImageUrl: (NSString *) imageUrl;
#endif
- (BOOL) imageUrlIsSet;

#if !__has_feature(objc_arc)
- (Timestamp) expires;
- (void) setExpires: (Timestamp) expires;
#endif
- (BOOL) expiresIsSet;

#if !__has_feature(objc_arc)
- (Timestamp) created;
- (void) setCreated: (Timestamp) created;
#endif
- (BOOL) createdIsSet;

#if !__has_feature(objc_arc)
- (Timestamp) updated;
- (void) setUpdated: (Timestamp) updated;
#endif
- (BOOL) updatedIsSet;

@end

@interface DealOffer_t : NSObject <NSCoding> {
  NSString * __dealOfferId;
  Merchant_t * __merchant;
  int __dealType;
  NSString * __title;
  NSString * __summary;
  NSString * __code;
  NSString * __imageUrl;
  double __price;
  Timestamp __expires;

  BOOL __dealOfferId_isset;
  BOOL __merchant_isset;
  BOOL __dealType_isset;
  BOOL __title_isset;
  BOOL __summary_isset;
  BOOL __code_isset;
  BOOL __imageUrl_isset;
  BOOL __price_isset;
  BOOL __expires_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=dealOfferId, setter=setDealOfferId:) NSString * dealOfferId;
@property (nonatomic, retain, getter=merchant, setter=setMerchant:) Merchant_t * merchant;
@property (nonatomic, getter=dealType, setter=setDealType:) int dealType;
@property (nonatomic, retain, getter=title, setter=setTitle:) NSString * title;
@property (nonatomic, retain, getter=summary, setter=setSummary:) NSString * summary;
@property (nonatomic, retain, getter=code, setter=setCode:) NSString * code;
@property (nonatomic, retain, getter=imageUrl, setter=setImageUrl:) NSString * imageUrl;
@property (nonatomic, getter=price, setter=setPrice:) double price;
@property (nonatomic, getter=expires, setter=setExpires:) Timestamp expires;
#endif

- (id) init;
- (id) initWithDealOfferId: (NSString *) dealOfferId merchant: (Merchant_t *) merchant dealType: (int) dealType title: (NSString *) title summary: (NSString *) summary code: (NSString *) code imageUrl: (NSString *) imageUrl price: (double) price expires: (Timestamp) expires;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (NSString *) dealOfferId;
- (void) setDealOfferId: (NSString *) dealOfferId;
#endif
- (BOOL) dealOfferIdIsSet;

#if !__has_feature(objc_arc)
- (Merchant_t *) merchant;
- (void) setMerchant: (Merchant_t *) merchant;
#endif
- (BOOL) merchantIsSet;

#if !__has_feature(objc_arc)
- (int) dealType;
- (void) setDealType: (int) dealType;
#endif
- (BOOL) dealTypeIsSet;

#if !__has_feature(objc_arc)
- (NSString *) title;
- (void) setTitle: (NSString *) title;
#endif
- (BOOL) titleIsSet;

#if !__has_feature(objc_arc)
- (NSString *) summary;
- (void) setSummary: (NSString *) summary;
#endif
- (BOOL) summaryIsSet;

#if !__has_feature(objc_arc)
- (NSString *) code;
- (void) setCode: (NSString *) code;
#endif
- (BOOL) codeIsSet;

#if !__has_feature(objc_arc)
- (NSString *) imageUrl;
- (void) setImageUrl: (NSString *) imageUrl;
#endif
- (BOOL) imageUrlIsSet;

#if !__has_feature(objc_arc)
- (double) price;
- (void) setPrice: (double) price;
#endif
- (BOOL) priceIsSet;

#if !__has_feature(objc_arc)
- (Timestamp) expires;
- (void) setExpires: (Timestamp) expires;
#endif
- (BOOL) expiresIsSet;

@end

@interface SearchOptions_t : NSObject <NSCoding> {
  BOOL __ascending;
  NSString * __sortProperty;
  int32_t __maxResults;
  int32_t __page;

  BOOL __ascending_isset;
  BOOL __sortProperty_isset;
  BOOL __maxResults_isset;
  BOOL __page_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=ascending, setter=setAscending:) BOOL ascending;
@property (nonatomic, retain, getter=sortProperty, setter=setSortProperty:) NSString * sortProperty;
@property (nonatomic, getter=maxResults, setter=setMaxResults:) int32_t maxResults;
@property (nonatomic, getter=page, setter=setPage:) int32_t page;
#endif

- (id) init;
- (id) initWithAscending: (BOOL) ascending sortProperty: (NSString *) sortProperty maxResults: (int32_t) maxResults page: (int32_t) page;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (BOOL) ascending;
- (void) setAscending: (BOOL) ascending;
#endif
- (BOOL) ascendingIsSet;

#if !__has_feature(objc_arc)
- (NSString *) sortProperty;
- (void) setSortProperty: (NSString *) sortProperty;
#endif
- (BOOL) sortPropertyIsSet;

#if !__has_feature(objc_arc)
- (int32_t) maxResults;
- (void) setMaxResults: (int32_t) maxResults;
#endif
- (BOOL) maxResultsIsSet;

#if !__has_feature(objc_arc)
- (int32_t) page;
- (void) setPage: (int32_t) page;
#endif
- (BOOL) pageIsSet;

@end

@interface DealAcquire_t : NSObject <NSCoding> {
  NSString * __dealAcquireId;
  Deal_t * __deal;
  NSString * __status;
  Merchant_t * __sharedByMerchant;
  Customer_t * __sharedByCustomer;
  int32_t __shareCount;
  Timestamp __redeemed;
  Timestamp __created;
  Timestamp __updated;

  BOOL __dealAcquireId_isset;
  BOOL __deal_isset;
  BOOL __status_isset;
  BOOL __sharedByMerchant_isset;
  BOOL __sharedByCustomer_isset;
  BOOL __shareCount_isset;
  BOOL __redeemed_isset;
  BOOL __created_isset;
  BOOL __updated_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=dealAcquireId, setter=setDealAcquireId:) NSString * dealAcquireId;
@property (nonatomic, retain, getter=deal, setter=setDeal:) Deal_t * deal;
@property (nonatomic, retain, getter=status, setter=setStatus:) NSString * status;
@property (nonatomic, retain, getter=sharedByMerchant, setter=setSharedByMerchant:) Merchant_t * sharedByMerchant;
@property (nonatomic, retain, getter=sharedByCustomer, setter=setSharedByCustomer:) Customer_t * sharedByCustomer;
@property (nonatomic, getter=shareCount, setter=setShareCount:) int32_t shareCount;
@property (nonatomic, getter=redeemed, setter=setRedeemed:) Timestamp redeemed;
@property (nonatomic, getter=created, setter=setCreated:) Timestamp created;
@property (nonatomic, getter=updated, setter=setUpdated:) Timestamp updated;
#endif

- (id) init;
- (id) initWithDealAcquireId: (NSString *) dealAcquireId deal: (Deal_t *) deal status: (NSString *) status sharedByMerchant: (Merchant_t *) sharedByMerchant sharedByCustomer: (Customer_t *) sharedByCustomer shareCount: (int32_t) shareCount redeemed: (Timestamp) redeemed created: (Timestamp) created updated: (Timestamp) updated;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (NSString *) dealAcquireId;
- (void) setDealAcquireId: (NSString *) dealAcquireId;
#endif
- (BOOL) dealAcquireIdIsSet;

#if !__has_feature(objc_arc)
- (Deal_t *) deal;
- (void) setDeal: (Deal_t *) deal;
#endif
- (BOOL) dealIsSet;

#if !__has_feature(objc_arc)
- (NSString *) status;
- (void) setStatus: (NSString *) status;
#endif
- (BOOL) statusIsSet;

#if !__has_feature(objc_arc)
- (Merchant_t *) sharedByMerchant;
- (void) setSharedByMerchant: (Merchant_t *) sharedByMerchant;
#endif
- (BOOL) sharedByMerchantIsSet;

#if !__has_feature(objc_arc)
- (Customer_t *) sharedByCustomer;
- (void) setSharedByCustomer: (Customer_t *) sharedByCustomer;
#endif
- (BOOL) sharedByCustomerIsSet;

#if !__has_feature(objc_arc)
- (int32_t) shareCount;
- (void) setShareCount: (int32_t) shareCount;
#endif
- (BOOL) shareCountIsSet;

#if !__has_feature(objc_arc)
- (Timestamp) redeemed;
- (void) setRedeemed: (Timestamp) redeemed;
#endif
- (BOOL) redeemedIsSet;

#if !__has_feature(objc_arc)
- (Timestamp) created;
- (void) setCreated: (Timestamp) created;
#endif
- (BOOL) createdIsSet;

#if !__has_feature(objc_arc)
- (Timestamp) updated;
- (void) setUpdated: (Timestamp) updated;
#endif
- (BOOL) updatedIsSet;

@end

@interface CoreConstants : NSObject {
}
@end
