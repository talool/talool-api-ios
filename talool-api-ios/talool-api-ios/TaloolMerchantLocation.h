//
//  TaloolMerchantLocation.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/16/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ttAddress, ttLocation, ttMerchant;

@interface TaloolMerchantLocation : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * locationId;
@property (nonatomic, retain) NSString * logoUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * websiteUrl;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) ttAddress *address;
@property (nonatomic, retain) ttLocation *location;
@property (nonatomic, retain) ttMerchant *merchant;

@end
