//
//  Created by Cory Zachman on 8/23/13.
//  Copyright (c) 2013 Cory Zachman. All rights reserved.
//

#import "TTLog.h"
#import "TestFlight.h"
#import "TaloolFrameworkHelper.h"

@implementation TTLog
+ (void)log:(char *)source lineNumber:(int)num withFormat:(NSString *)format, ...
{

    // This will limit what we can see in TestFlight
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

    // Use TestFlight's logging that will also log remotely
    TFLog(@"%@ (%i) :: %@",[file lastPathComponent],num,message);
    
}
@end
