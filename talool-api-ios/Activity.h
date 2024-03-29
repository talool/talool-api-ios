/**
 * Autogenerated by Thrift Compiler (0.9.1)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */

#import <Foundation/Foundation.h>

#import "TProtocol.h"
#import "TApplicationException.h"
#import "TProtocolException.h"
#import "TProtocolUtil.h"
#import "TProcessor.h"
#import "TObjective-C.h"
#import "TBase.h"

#import "Core.h"

enum ActivityEvent_t {
  ActivityEvent_t_UNKNOWN = 0,
  ActivityEvent_t_WELCOME = 1,
  ActivityEvent_t_PURCHASE = 2,
  ActivityEvent_t_REDEEM = 3,
  ActivityEvent_t_REJECT_GIFT = 4,
  ActivityEvent_t_FACEBOOK_RECV_GIFT = 5,
  ActivityEvent_t_FACEBOOK_SEND_GIFT = 6,
  ActivityEvent_t_EMAIL_RECV_GIFT = 7,
  ActivityEvent_t_EMAIL_SEND_GIFT = 8,
  ActivityEvent_t_FRIEND_GIFT_ACCEPT = 9,
  ActivityEvent_t_FRIEND_GIFT_REJECT = 10,
  ActivityEvent_t_FRIEND_GIFT_REDEEM = 11,
  ActivityEvent_t_FRIEND_PURCHASE_DEAL_OFFER = 12,
  ActivityEvent_t_MERCHANT_REACH = 13,
  ActivityEvent_t_TALOOL_REACH = 14,
  ActivityEvent_t_AD = 15,
  ActivityEvent_t_FUNDRAISER_SUPPORT = 16
};

enum LinkType {
  LinkType_MERCHANT = 0,
  LinkType_DEAL = 1,
  LinkType_DEAL_OFFER = 2,
  LinkType_GIFT = 3,
  LinkType_CUSTOMER = 4,
  LinkType_DEAL_ACQUIRE = 5,
  LinkType_MERCHANT_LOCATION = 6,
  LinkType_EXTERNAL = 7,
  LinkType_EMAIL = 8
};

@interface ActivityLink_t : NSObject <TBase, NSCoding> {
  int __linkType;
  NSString * __linkElement;
  NSMutableDictionary * __properties;

  BOOL __linkType_isset;
  BOOL __linkElement_isset;
  BOOL __properties_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=linkType, setter=setLinkType:) int linkType;
@property (nonatomic, retain, getter=linkElement, setter=setLinkElement:) NSString * linkElement;
@property (nonatomic, retain, getter=properties, setter=setProperties:) NSMutableDictionary * properties;
#endif

- (id) init;
- (id) initWithLinkType: (int) linkType linkElement: (NSString *) linkElement properties: (NSMutableDictionary *) properties;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (void) validate;

#if !__has_feature(objc_arc)
- (int) linkType;
- (void) setLinkType: (int) linkType;
#endif
- (BOOL) linkTypeIsSet;

#if !__has_feature(objc_arc)
- (NSString *) linkElement;
- (void) setLinkElement: (NSString *) linkElement;
#endif
- (BOOL) linkElementIsSet;

#if !__has_feature(objc_arc)
- (NSMutableDictionary *) properties;
- (void) setProperties: (NSMutableDictionary *) properties;
#endif
- (BOOL) propertiesIsSet;

@end

@interface Activity_t : NSObject <TBase, NSCoding> {
  NSString * __activityId;
  Timestamp __activityDate;
  NSString * __title;
  NSString * __subtitle;
  NSString * __icon;
  ActivityLink_t * __activityLink;
  int __activityEvent;
  BOOL __actionTaken;

  BOOL __activityId_isset;
  BOOL __activityDate_isset;
  BOOL __title_isset;
  BOOL __subtitle_isset;
  BOOL __icon_isset;
  BOOL __activityLink_isset;
  BOOL __activityEvent_isset;
  BOOL __actionTaken_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=activityId, setter=setActivityId:) NSString * activityId;
@property (nonatomic, getter=activityDate, setter=setActivityDate:) Timestamp activityDate;
@property (nonatomic, retain, getter=title, setter=setTitle:) NSString * title;
@property (nonatomic, retain, getter=subtitle, setter=setSubtitle:) NSString * subtitle;
@property (nonatomic, retain, getter=icon, setter=setIcon:) NSString * icon;
@property (nonatomic, retain, getter=activityLink, setter=setActivityLink:) ActivityLink_t * activityLink;
@property (nonatomic, getter=activityEvent, setter=setActivityEvent:) int activityEvent;
@property (nonatomic, getter=actionTaken, setter=setActionTaken:) BOOL actionTaken;
#endif

- (id) init;
- (id) initWithActivityId: (NSString *) activityId activityDate: (Timestamp) activityDate title: (NSString *) title subtitle: (NSString *) subtitle icon: (NSString *) icon activityLink: (ActivityLink_t *) activityLink activityEvent: (int) activityEvent actionTaken: (BOOL) actionTaken;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (void) validate;

#if !__has_feature(objc_arc)
- (NSString *) activityId;
- (void) setActivityId: (NSString *) activityId;
#endif
- (BOOL) activityIdIsSet;

#if !__has_feature(objc_arc)
- (Timestamp) activityDate;
- (void) setActivityDate: (Timestamp) activityDate;
#endif
- (BOOL) activityDateIsSet;

#if !__has_feature(objc_arc)
- (NSString *) title;
- (void) setTitle: (NSString *) title;
#endif
- (BOOL) titleIsSet;

#if !__has_feature(objc_arc)
- (NSString *) subtitle;
- (void) setSubtitle: (NSString *) subtitle;
#endif
- (BOOL) subtitleIsSet;

#if !__has_feature(objc_arc)
- (NSString *) icon;
- (void) setIcon: (NSString *) icon;
#endif
- (BOOL) iconIsSet;

#if !__has_feature(objc_arc)
- (ActivityLink_t *) activityLink;
- (void) setActivityLink: (ActivityLink_t *) activityLink;
#endif
- (BOOL) activityLinkIsSet;

#if !__has_feature(objc_arc)
- (int) activityEvent;
- (void) setActivityEvent: (int) activityEvent;
#endif
- (BOOL) activityEventIsSet;

#if !__has_feature(objc_arc)
- (BOOL) actionTaken;
- (void) setActionTaken: (BOOL) actionTaken;
#endif
- (BOOL) actionTakenIsSet;

@end

@interface ActivityConstants : NSObject {
}
@end
