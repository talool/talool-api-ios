//
//  TaloolMerchantLocation.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/17/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ttMerchant;

@interface TaloolMerchantLocation : NSManagedObject

@property (nonatomic, retain) NSNumber * distanceInMeters;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * locationId;
@property (nonatomic, retain) NSString * logoUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * websiteUrl;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * stateProvidenceCounty;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) ttMerchant *merchant;

@end
