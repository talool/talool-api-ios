//
//  ttToken.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/16/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaloolToken.h"

@class CTokenAccess_t;

@interface ttToken : TaloolToken

+ (ttToken *)initWithThrift: (CTokenAccess_t *)token context:(NSManagedObjectContext *)context;

@end
