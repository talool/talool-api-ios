//
//  ttCategory.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/17/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttCategory.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttCategory

+ (ttCategory *)initWithThrift: (Category_t *)category context:(NSManagedObjectContext *)context
{
    ttCategory *c = (ttCategory *)[NSEntityDescription
                                 insertNewObjectForEntityForName:CATEGORY_ENTITY_NAME
                                 inManagedObjectContext:context];
    c.name = category.name;
    c.categoryId = [[NSNumber alloc] initWithInt:category.categoryId];
    
    return c;
}

- (Category_t *)hydrateThriftObject
{
    Category_t *cat = [[Category_t alloc] init];
    
    cat.name = self.name;
    cat.categoryId = [self.categoryId intValue];
    
    return cat;
}

@end
