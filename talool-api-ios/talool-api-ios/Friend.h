//
//  Friend.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/24/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friend : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * isCustomer;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * socialNetwork;

@end
