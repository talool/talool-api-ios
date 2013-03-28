//
//  TaloolMerchant.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/27/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolDeal;

@interface TaloolMerchant : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *deals;
@end

@interface TaloolMerchant (CoreDataGeneratedAccessors)

- (void)addDealsObject:(TaloolDeal *)value;
- (void)removeDealsObject:(TaloolDeal *)value;
- (void)addDeals:(NSSet *)values;
- (void)removeDeals:(NSSet *)values;

@end
