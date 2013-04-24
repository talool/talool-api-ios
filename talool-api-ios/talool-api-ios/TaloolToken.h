//
//  TaloolToken.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/24/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolCustomer;

@interface TaloolToken : NSManagedObject

@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) TaloolCustomer *customer;

@end
