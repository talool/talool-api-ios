//
//  Created by Cory Zachman on 8/23/13.
//  Copyright (c) 2013 Cory Zachman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTLog : NSObject
+ (void)log:(char *)source lineNumber:(int)num withFormat:(NSString *)format, ...;

#ifndef TTLog
#define TTLog(s,...) [TTLog log:__FILE__ lineNumber:__LINE__ withFormat:(s),##__VA_ARGS__]
#endif

@end
