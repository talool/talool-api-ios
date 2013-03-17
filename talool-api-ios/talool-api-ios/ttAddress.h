//
//  ttAddress.h
//  mobile
//
//  Created by Douglas McCuen on 3/2/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolAddress.h"

@class Address_t;

@interface ttAddress : TaloolAddress

- (BOOL)isValid;
+ (ttAddress *)initWithThrift: (Address_t *)address context:(NSManagedObjectContext *)context;
- (Address_t *)hydrateThriftObject;

@end
