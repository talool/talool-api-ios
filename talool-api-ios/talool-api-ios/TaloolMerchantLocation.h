//
//  TaloolMerchantLocation.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/24/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolAddress, TaloolMerchant;

@interface TaloolMerchantLocation : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * locationId;
@property (nonatomic, retain) NSString * logoUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * websiteUrl;
@property (nonatomic, retain) TaloolAddress *address;
@property (nonatomic, retain) TaloolMerchant *merchant;

@end
