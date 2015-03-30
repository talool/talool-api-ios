//
//  Created by Cory Zachman on 8/23/13.
//  Copyright (c) 2013 Cory Zachman. All rights reserved.
//

#import "TTLog.h"
#import "TaloolFrameworkHelper.h"

@implementation TTLog
+ (void)log:(char *)source lineNumber:(int)num withFormat:(NSString *)format, ...
{

    if ([[TaloolFrameworkHelper sharedInstance] isProduction])
    {
        return;
    }
    
    NSString *message = nil;
    NSString *file = nil;
    va_list args;
    
    va_start(args, format);
    message = [[NSString alloc] initWithFormat:format arguments:args];
    file = [[NSString alloc] initWithBytes:source length:strlen(source) encoding:NSUTF8StringEncoding];
    va_end(args);

    NSLog(@"%@ (%i) :: %@",[file lastPathComponent],num,message);
    
}
@end
