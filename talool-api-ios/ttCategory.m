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
    // see if we have this entity already
    ttCategory *c = [ttCategory fetchById:[NSNumber numberWithInt:category.categoryId] context:context];
    if (!c)
    {
        c = (ttCategory *)[NSEntityDescription
                           insertNewObjectForEntityForName:CATEGORY_ENTITY_NAME
                           inManagedObjectContext:context];
    }
    
    // update the object
    c.name = category.name;
    c.categoryId = [[NSNumber alloc] initWithInt:category.categoryId];
    
    return c;
}

+ (ttCategory *) fetchById:(NSNumber *)catId context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.categoryId = %@", catId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CATEGORY_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    NSError *error;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if ([mutableFetchResults count] == 1)
    {
        return [mutableFetchResults objectAtIndex:0];
    }
    return nil;
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
    
    if ([cats count]==0)
    {
        // pull any existing catagories from the context
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:CATEGORY_ENTITY_NAME inManagedObjectContext:context];
        [request setEntity:entity];
        NSError *error;
        cats = [context executeFetchRequest:request error:&error];
        NSLog(@"Pulled %d categories in the context", [cats count]);
    }
    
    return cats;
}

@end
