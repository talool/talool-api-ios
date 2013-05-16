//
//  ttLocation.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/16/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolLocation.h"

@class Location_t;

@interface ttLocation : TaloolLocation

+ (ttLocation *)initWithThrift: (Location_t *)location context:(NSManagedObjectContext *)context;
- (Location_t *)hydrateThriftObject;

@end
