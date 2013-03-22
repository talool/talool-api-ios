//
//  Friend.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/21/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ttCustomer;

@interface Friend : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * socialNetwork;
@property (nonatomic, retain) NSNumber * isCustomer;
@property (nonatomic, retain) ttCustomer *customer;

@end
