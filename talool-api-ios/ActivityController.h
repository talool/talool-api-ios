//
//  ActivityController.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/27/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolThriftController.h"

@class ttCustomer;

@interface ActivityController : TaloolThriftController


- (NSMutableArray *) getActivities:(ttCustomer *)customer error:(NSError**)error;
- (NSMutableArray *) getMessages:(ttCustomer *)customer
                        latitude:(double)latitude
                       longitude:(double)longitude
                           error:(NSError**)error;

- (NSString *) getEmail:(ttCustomer *)customer
               template:(NSString *)templateId
                 entity:(NSString *)entityId
                  error:(NSError **)error;

- (BOOL) actionTaken:(ttCustomer *)customer actionId:(NSString *)actionId error:(NSError**)error;


@end
