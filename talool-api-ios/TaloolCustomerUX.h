//
//  TaloolCustomerUX.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/5/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolCustomer;

@interface TaloolCustomerUX : NSManagedObject

@property (nonatomic, retain) NSNumber * redeemPreviewCount;
@property (nonatomic, retain) NSNumber * hasRedeemed;
@property (nonatomic, retain) NSNumber * hasShared;
@property (nonatomic, retain) NSNumber * hasPurchased;
@property (nonatomic, retain) TaloolCustomer *customer;

@end
