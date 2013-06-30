//
//  TaloolActivity.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/26/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolActivityLink;

@interface TaloolActivity : NSManagedObject

@property (nonatomic, retain) NSDate * activityDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSNumber * event;
@property (nonatomic, retain) NSNumber * closedState;
@property (nonatomic, retain) TaloolActivityLink *link;

@end
