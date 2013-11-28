//
//  ttCategory.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/17/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolCategory.h"

@class Category_t, ttCustomer;

@interface ttCategory : TaloolCategory

+ (BOOL)getCategories:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)err;
+ (ttCategory *)initWithThrift: (Category_t *)category context:(NSManagedObjectContext *)context;

@end
