//
//  TaloolAddress.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/16/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolMerchantLocation;

@interface TaloolAddress : NSManagedObject

@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * stateProvidenceCounty;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) TaloolMerchantLocation *merchantLocation;

@end
