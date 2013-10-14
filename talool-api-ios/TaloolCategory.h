//
//  TaloolCategory.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/17/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaloolMerchant;

@interface TaloolCategory : NSManagedObject

@property (nonatomic, retain) NSNumber * categoryId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *merchants;
@end

@interface TaloolCategory (CoreDataGeneratedAccessors)

- (void)addMerchantObject:(TaloolMerchant *)value;
- (void)removeMerchantObject:(TaloolMerchant *)value;
- (void)addMerchants:(NSSet *)values;
- (void)removeMerchants:(NSSet *)values;

@end
