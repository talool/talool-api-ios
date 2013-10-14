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

#import "Core.h"

#import "Activity.h"

@implementation ActivityLink_t

- (id) init
{
  self = [super init];
#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
#endif
  return self;
}

- (id) initWithLinkType: (int) linkType linkElement: (NSString *) linkElement
{
  self = [super init];
  __linkType = linkType;
  __linkType_isset = YES;
  __linkElement = [linkElement retain_stub];
  __linkElement_isset = YES;
  return self;
}

- (id) initWithCoder: (NSCoder *) decoder
{
  self = [super init];
  if ([decoder containsValueForKey: @"linkType"])
  {
    __linkType = [decoder decodeIntForKey: @"linkType"];
    __linkType_isset = YES;
  }
  if ([decoder containsValueForKey: @"linkElement"])
  {
    __linkElement = [[decoder decodeObjectForKey: @"linkElement"] retain_stub];
    __linkElement_isset = YES;
  }
  return self;
}

- (void) encodeWithCoder: (NSCoder *) encoder
{
  if (__linkType_isset)
  {
    [encoder encodeInt: __linkType forKey: @"linkType"];
  }
  if (__linkElement_isset)
  {
    [encoder encodeObject: __linkElement forKey: @"linkElement"];
  }
}

- (void) dealloc
{
  [__linkElement release_stub];
  [super dealloc_stub];
}

- (int) linkType {
  return __linkType;
}

- (void) setLinkType: (int) linkType {
  __linkType = linkType;
  __linkType_isset = YES;
}

- (BOOL) linkTypeIsSet {
  return __linkType_isset;
}

- (void) unsetLinkType {
  __linkType_isset = NO;
}

- (NSString *) linkElement {
  return [[__linkElement retain_stub] autorelease_stub];
}

- (void) setLinkElement: (NSString *) linkElement {
  [linkElement retain_stub];
  [__linkElement release_stub];
  __linkElement = linkElement;
  __linkElement_isset = YES;
}

- (BOOL) linkElementIsSet {
  return __linkElement_isset;
}

- (void) unsetLinkElement {
  [__linkElement release_stub];
  __linkElement = nil;
  __linkElement_isset = NO;
}

- (void) read: (id <TProtocol>) inProtocol
{
  NSString * fieldName;
  int fieldType;
  int fieldID;

  [inProtocol readStructBeginReturningName: NULL];
  while (true)
  {
    [inProtocol readFieldBeginReturningName: &fieldName type: &fieldType fieldID: &fieldID];
    if (fieldType == TType_STOP) { 
      break;
    }
    switch (fieldID)
    {
      case 1:
        if (fieldType == TType_I32) {
          int fieldValue = [inProtocol readI32];
          [self setLinkType: fieldValue];
        } else { 
          [TProtocolUtil skipType: fieldType onProtocol: inProtocol];
        }
        break;
      case 2:
        if (fieldType == TType_STRING) {
          NSString * fieldValue = [inProtocol readString];
          [self setLinkElement: fieldValue];
        } else { 
          [TProtocolUtil skipType: fieldType onProtocol: inProtocol];
        }
        break;
      default:
        [TProtocolUtil skipType: fieldType onProtocol: inProtocol];
        break;
    }
    [inProtocol readFieldEnd];
  }
  [inProtocol readStructEnd];
}

- (void) write: (id <TProtocol>) outProtocol {
  [outProtocol writeStructBeginWithName: @"ActivityLink_t"];
  if (__linkType_isset) {
    [outProtocol writeFieldBeginWithName: @"linkType" type: TType_I32 fieldID: 1];
    [outProtocol writeI32: __linkType];
    [outProtocol writeFieldEnd];
  }
  if (__linkElement_isset) {
    if (__linkElement != nil) {
      [outProtocol writeFieldBeginWithName: @"linkElement" type: TType_STRING fieldID: 2];
      [outProtocol writeString: __linkElement];
      [outProtocol writeFieldEnd];
    }
  }
  [outProtocol writeFieldStop];
  [outProtocol writeStructEnd];
}

- (NSString *) description {
  NSMutableString * ms = [NSMutableString stringWithString: @"ActivityLink_t("];
  [ms appendString: @"linkType:"];
  [ms appendFormat: @"%i", __linkType];
  [ms appendString: @",linkElement:"];
  [ms appendFormat: @"\"%@\"", __linkElement];
  [ms appendString: @")"];
  return [NSString stringWithString: ms];
}

@end

@implementation Activity_t

- (id) init
{
  self = [super init];
#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
  self.actionTaken = NO;

#endif
  return self;
}

- (id) initWithActivityId: (NSString *) activityId activityDate: (Timestamp) activityDate title: (NSString *) title subtitle: (NSString *) subtitle icon: (NSString *) icon activityLink: (ActivityLink_t *) activityLink activityEvent: (int) activityEvent actionTaken: (BOOL) actionTaken
{
  self = [super init];
  __activityId = [activityId retain_stub];
  __activityId_isset = YES;
  __activityDate = activityDate;
  __activityDate_isset = YES;
  __title = [title retain_stub];
  __title_isset = YES;
  __subtitle = [subtitle retain_stub];
  __subtitle_isset = YES;
  __icon = [icon retain_stub];
  __icon_isset = YES;
  __activityLink = [activityLink retain_stub];
  __activityLink_isset = YES;
  __activityEvent = activityEvent;
  __activityEvent_isset = YES;
  __actionTaken = actionTaken;
  __actionTaken_isset = YES;
  return self;
}

- (id) initWithCoder: (NSCoder *) decoder
{
  self = [super init];
  if ([decoder containsValueForKey: @"activityId"])
  {
    __activityId = [[decoder decodeObjectForKey: @"activityId"] retain_stub];
    __activityId_isset = YES;
  }
  if ([decoder containsValueForKey: @"activityDate"])
  {
    __activityDate = [decoder decodeInt64ForKey: @"activityDate"];
    __activityDate_isset = YES;
  }
  if ([decoder containsValueForKey: @"title"])
  {
    __title = [[decoder decodeObjectForKey: @"title"] retain_stub];
    __title_isset = YES;
  }
  if ([decoder containsValueForKey: @"subtitle"])
  {
    __subtitle = [[decoder decodeObjectForKey: @"subtitle"] retain_stub];
    __subtitle_isset = YES;
  }
  if ([decoder containsValueForKey: @"icon"])
  {
    __icon = [[decoder decodeObjectForKey: @"icon"] retain_stub];
    __icon_isset = YES;
  }
  if ([decoder containsValueForKey: @"activityLink"])
  {
    __activityLink = [[decoder decodeObjectForKey: @"activityLink"] retain_stub];
    __activityLink_isset = YES;
  }
  if ([decoder containsValueForKey: @"activityEvent"])
  {
    __activityEvent = [decoder decodeIntForKey: @"activityEvent"];
    __activityEvent_isset = YES;
  }
  if ([decoder containsValueForKey: @"actionTaken"])
  {
    __actionTaken = [decoder decodeBoolForKey: @"actionTaken"];
    __actionTaken_isset = YES;
  }
  return self;
}

- (void) encodeWithCoder: (NSCoder *) encoder
{
  if (__activityId_isset)
  {
    [encoder encodeObject: __activityId forKey: @"activityId"];
  }
  if (__activityDate_isset)
  {
    [encoder encodeInt64: __activityDate forKey: @"activityDate"];
  }
  if (__title_isset)
  {
    [encoder encodeObject: __title forKey: @"title"];
  }
  if (__subtitle_isset)
  {
    [encoder encodeObject: __subtitle forKey: @"subtitle"];
  }
  if (__icon_isset)
  {
    [encoder encodeObject: __icon forKey: @"icon"];
  }
  if (__activityLink_isset)
  {
    [encoder encodeObject: __activityLink forKey: @"activityLink"];
  }
  if (__activityEvent_isset)
  {
    [encoder encodeInt: __activityEvent forKey: @"activityEvent"];
  }
  if (__actionTaken_isset)
  {
    [encoder encodeBool: __actionTaken forKey: @"actionTaken"];
  }
}

- (void) dealloc
{
  [__activityId release_stub];
  [__title release_stub];
  [__subtitle release_stub];
  [__icon release_stub];
  [__activityLink release_stub];
  [super dealloc_stub];
}

- (NSString *) activityId {
  return [[__activityId retain_stub] autorelease_stub];
}

- (void) setActivityId: (NSString *) activityId {
  [activityId retain_stub];
  [__activityId release_stub];
  __activityId = activityId;
  __activityId_isset = YES;
}

- (BOOL) activityIdIsSet {
  return __activityId_isset;
}

- (void) unsetActivityId {
  [__activityId release_stub];
  __activityId = nil;
  __activityId_isset = NO;
}

- (int64_t) activityDate {
  return __activityDate;
}

- (void) setActivityDate: (int64_t) activityDate {
  __activityDate = activityDate;
  __activityDate_isset = YES;
}

- (BOOL) activityDateIsSet {
  return __activityDate_isset;
}

- (void) unsetActivityDate {
  __activityDate_isset = NO;
}

- (NSString *) title {
  return [[__title retain_stub] autorelease_stub];
}

- (void) setTitle: (NSString *) title {
  [title retain_stub];
  [__title release_stub];
  __title = title;
  __title_isset = YES;
}

- (BOOL) titleIsSet {
  return __title_isset;
}

- (void) unsetTitle {
  [__title release_stub];
  __title = nil;
  __title_isset = NO;
}

- (NSString *) subtitle {
  return [[__subtitle retain_stub] autorelease_stub];
}

- (void) setSubtitle: (NSString *) subtitle {
  [subtitle retain_stub];
  [__subtitle release_stub];
  __subtitle = subtitle;
  __subtitle_isset = YES;
}

- (BOOL) subtitleIsSet {
  return __subtitle_isset;
}

- (void) unsetSubtitle {
  [__subtitle release_stub];
  __subtitle = nil;
  __subtitle_isset = NO;
}

- (NSString *) icon {
  return [[__icon retain_stub] autorelease_stub];
}

- (void) setIcon: (NSString *) icon {
  [icon retain_stub];
  [__icon release_stub];
  __icon = icon;
  __icon_isset = YES;
}

- (BOOL) iconIsSet {
  return __icon_isset;
}

- (void) unsetIcon {
  [__icon release_stub];
  __icon = nil;
  __icon_isset = NO;
}

- (ActivityLink_t *) activityLink {
  return [[__activityLink retain_stub] autorelease_stub];
}

- (void) setActivityLink: (ActivityLink_t *) activityLink {
  [activityLink retain_stub];
  [__activityLink release_stub];
  __activityLink = activityLink;
  __activityLink_isset = YES;
}

- (BOOL) activityLinkIsSet {
  return __activityLink_isset;
}

- (void) unsetActivityLink {
  [__activityLink release_stub];
  __activityLink = nil;
  __activityLink_isset = NO;
}

- (int) activityEvent {
  return __activityEvent;
}

- (void) setActivityEvent: (int) activityEvent {
  __activityEvent = activityEvent;
  __activityEvent_isset = YES;
}

- (BOOL) activityEventIsSet {
  return __activityEvent_isset;
}

- (void) unsetActivityEvent {
  __activityEvent_isset = NO;
}

- (BOOL) actionTaken {
  return __actionTaken;
}

- (void) setActionTaken: (BOOL) actionTaken {
  __actionTaken = actionTaken;
  __actionTaken_isset = YES;
}

- (BOOL) actionTakenIsSet {
  return __actionTaken_isset;
}

- (void) unsetActionTaken {
  __actionTaken_isset = NO;
}

- (void) read: (id <TProtocol>) inProtocol
{
  NSString * fieldName;
  int fieldType;
  int fieldID;

  [inProtocol readStructBeginReturningName: NULL];
  while (true)
  {
    [inProtocol readFieldBeginReturningName: &fieldName type: &fieldType fieldID: &fieldID];
    if (fieldType == TType_STOP) { 
      break;
    }
    switch (fieldID)
    {
      case 1:
        if (fieldType == TType_STRING) {
          NSString * fieldValue = [inProtocol readString];
          [self setActivityId: fieldValue];
        } else { 
          [TProtocolUtil skipType: fieldType onProtocol: inProtocol];
        }
        break;
      case 2:
        if (fieldType == TType_I64) {
          int64_t fieldValue = [inProtocol readI64];
          [self setActivityDate: fieldValue];
        } else { 
          [TProtocolUtil skipType: fieldType onProtocol: inProtocol];
        }
        break;
      case 3:
        if (fieldType == TType_STRING) {
          NSString * fieldValue = [inProtocol readString];
          [self setTitle: fieldValue];
        } else { 
          [TProtocolUtil skipType: fieldType onProtocol: inProtocol];
        }
        break;
      case 4:
        if (fieldType == TType_STRING) {
          NSString * fieldValue = [inProtocol readString];
          [self setSubtitle: fieldValue];
        } else { 
          [TProtocolUtil skipType: fieldType onProtocol: inProtocol];
        }
        break;
      case 5:
        if (fieldType == TType_STRING) {
          NSString * fieldValue = [inProtocol readString];
          [self setIcon: fieldValue];
        } else { 
          [TProtocolUtil skipType: fieldType onProtocol: inProtocol];
        }
        break;
      case 6:
        if (fieldType == TType_STRUCT) {
          ActivityLink_t *fieldValue = [[ActivityLink_t alloc] init];
          [fieldValue read: inProtocol];
          [self setActivityLink: fieldValue];
          [fieldValue release_stub];
        } else { 
          [TProtocolUtil skipType: fieldType onProtocol: inProtocol];
        }
        break;
      case 7:
        if (fieldType == TType_I32) {
          int fieldValue = [inProtocol readI32];
          [self setActivityEvent: fieldValue];
        } else { 
          [TProtocolUtil skipType: fieldType onProtocol: inProtocol];
        }
        break;
      case 8:
        if (fieldType == TType_BOOL) {
          BOOL fieldValue = [inProtocol readBool];
          [self setActionTaken: fieldValue];
        } else { 
          [TProtocolUtil skipType: fieldType onProtocol: inProtocol];
        }
        break;
      default:
        [TProtocolUtil skipType: fieldType onProtocol: inProtocol];
        break;
    }
    [inProtocol readFieldEnd];
  }
  [inProtocol readStructEnd];
}

- (void) write: (id <TProtocol>) outProtocol {
  [outProtocol writeStructBeginWithName: @"Activity_t"];
  if (__activityId_isset) {
    if (__activityId != nil) {
      [outProtocol writeFieldBeginWithName: @"activityId" type: TType_STRING fieldID: 1];
      [outProtocol writeString: __activityId];
      [outProtocol writeFieldEnd];
    }
  }
  if (__activityDate_isset) {
    [outProtocol writeFieldBeginWithName: @"activityDate" type: TType_I64 fieldID: 2];
    [outProtocol writeI64: __activityDate];
    [outProtocol writeFieldEnd];
  }
  if (__title_isset) {
    if (__title != nil) {
      [outProtocol writeFieldBeginWithName: @"title" type: TType_STRING fieldID: 3];
      [outProtocol writeString: __title];
      [outProtocol writeFieldEnd];
    }
  }
  if (__subtitle_isset) {
    if (__subtitle != nil) {
      [outProtocol writeFieldBeginWithName: @"subtitle" type: TType_STRING fieldID: 4];
      [outProtocol writeString: __subtitle];
      [outProtocol writeFieldEnd];
    }
  }
  if (__icon_isset) {
    if (__icon != nil) {
      [outProtocol writeFieldBeginWithName: @"icon" type: TType_STRING fieldID: 5];
      [outProtocol writeString: __icon];
      [outProtocol writeFieldEnd];
    }
  }
  if (__activityLink_isset) {
    if (__activityLink != nil) {
      [outProtocol writeFieldBeginWithName: @"activityLink" type: TType_STRUCT fieldID: 6];
      [__activityLink write: outProtocol];
      [outProtocol writeFieldEnd];
    }
  }
  if (__activityEvent_isset) {
    [outProtocol writeFieldBeginWithName: @"activityEvent" type: TType_I32 fieldID: 7];
    [outProtocol writeI32: __activityEvent];
    [outProtocol writeFieldEnd];
  }
  if (__actionTaken_isset) {
    [outProtocol writeFieldBeginWithName: @"actionTaken" type: TType_BOOL fieldID: 8];
    [outProtocol writeBool: __actionTaken];
    [outProtocol writeFieldEnd];
  }
  [outProtocol writeFieldStop];
  [outProtocol writeStructEnd];
}

- (NSString *) description {
  NSMutableString * ms = [NSMutableString stringWithString: @"Activity_t("];
  [ms appendString: @"activityId:"];
  [ms appendFormat: @"\"%@\"", __activityId];
  [ms appendString: @",activityDate:"];
  [ms appendFormat: @"%qi", __activityDate];
  [ms appendString: @",title:"];
  [ms appendFormat: @"\"%@\"", __title];
  [ms appendString: @",subtitle:"];
  [ms appendFormat: @"\"%@\"", __subtitle];
  [ms appendString: @",icon:"];
  [ms appendFormat: @"\"%@\"", __icon];
  [ms appendString: @",activityLink:"];
  [ms appendFormat: @"%@", __activityLink];
  [ms appendString: @",activityEvent:"];
  [ms appendFormat: @"%i", __activityEvent];
  [ms appendString: @",actionTaken:"];
  [ms appendFormat: @"%i", __actionTaken];
  [ms appendString: @")"];
  return [NSString stringWithString: ms];
}

@end


@implementation ActivityConstants
+ (void) initialize {
}
@end
