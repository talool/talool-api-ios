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
#import "CustomerController.h"

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

+ (NSArray *)getCategories:(ttCustomer *)customer context:(NSManagedObjectContext *)context
{
    CustomerController *cController = [[CustomerController alloc] init];
    NSError *error;
    NSArray *cats = [cController getCategories:customer context:context error:&error];
    
    return cats;
}

@end
