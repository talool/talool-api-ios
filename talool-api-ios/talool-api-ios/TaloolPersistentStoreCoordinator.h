//
//  TaloolPersistentStoreCoordinator.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/9/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TaloolPersistentStoreCoordinator : NSObject

+(NSPersistentStoreCoordinator *) initWithStoreUrl:(NSURL *)storeURL;
+(NSManagedObjectModel *) managedObjectModel;

@end
