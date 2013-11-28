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
#import "MerchantController.h"
#import "APIErrorManager.h"

@implementation ttCategory


#pragma mark -
#pragma mark - Create or Update the Core Data Object

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



#pragma mark -
#pragma mark - Get the Categories

+ (BOOL)getCategories:(ttCustomer *)customer context:(NSManagedObjectContext *)context error:(NSError **)error
{
    BOOL result = NO;
    
    MerchantController *mc = [[MerchantController alloc] init];
    NSArray *cats = [mc getCategories:customer error:error];
    
    if (cats && !error)
    {
        @try {
            // transform the Thrift response and save the context
            for (Category_t *cat in cats) [ttCategory initWithThrift:cat context:context];
            result = [context save:error];
        }
        @catch (NSException * e) {
            [mc.errorManager handleCoreDataException:e forMethod:@"getCategories" entity:@"ttCategory" error:error];
        }
    }
    
    return result;
}

@end
