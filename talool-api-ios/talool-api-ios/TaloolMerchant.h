//
//  TaloolMerchant.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/28/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolAddress, TaloolCustomer, TaloolDeal;

@interface TaloolMerchant : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * websiteUrl;
@property (nonatomic, retain) NSString * logoUrl;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * merchantId;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSSet *deals;
@property (nonatomic, retain) TaloolAddress *address;
@property (nonatomic, retain) TaloolCustomer *customer;
@end

@interface TaloolMerchant (CoreDataGeneratedAccessors)

- (void)addDealsObject:(TaloolDeal *)value;
- (void)removeDealsObject:(TaloolDeal *)value;
- (void)addDeals:(NSSet *)values;
- (void)removeDeals:(NSSet *)values;

@end
