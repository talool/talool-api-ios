//
//  TaloolActivityLink.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/26/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolActivity;

@interface TaloolActivityLink : NSManagedObject

@property (nonatomic, retain) NSNumber * linkType;
@property (nonatomic, retain) NSString * elementId;
@property (nonatomic, retain) TaloolActivity *activity;

@end
