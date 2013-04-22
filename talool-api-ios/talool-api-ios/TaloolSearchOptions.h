//
//  TaloolSearchOptions.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/22/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TaloolSearchOptions : NSManagedObject

@property (nonatomic, retain) NSNumber * sortType;
@property (nonatomic, retain) NSString * sortProperty;
@property (nonatomic, retain) NSNumber * firstResult;
@property (nonatomic, retain) NSNumber * maxResults;
@property (nonatomic, retain) NSNumber * page;

@end
