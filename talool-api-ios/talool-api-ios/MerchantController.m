//
//  MerchantController.m
//  mobile
//
//  Created by Douglas McCuen on 2/18/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "MerchantController.h"
#import "Core.h"
#import "ttMerchant.h"
#import "ttCustomer.h"
#import "ttCoupon.h"
#import "TaloolFrameworkHelper.h"


@implementation MerchantController

@synthesize merchants;


- (id)init {
	if ((self = [super init])) {
		// do something cool
	}
	return self;
}

/*
 Create the Merchant objects and initialize them from a plist.
 Eventually, we'll get this from the API
 */
- (void)loadData:(NSManagedObjectContext *)context
{
	merchants = [[NSMutableArray alloc] initWithArray:[MerchantController getData:context]];

}

- (unsigned)countOfMerchants {
    return [merchants count];
}

- (id)objectInMerchantsAtIndex:(unsigned)theIndex {
    return [merchants objectAtIndex:theIndex];
}

- (NSMutableArray *) getCouponsByMerchant:(ttMerchant *)merchant forCustomer:(ttCustomer *)customer context:(NSManagedObjectContext *)context
{
    NSMutableArray *coupons = [[NSMutableArray alloc] initWithCapacity:0];
    
    // Create the data model.
    NSString *path = [[TaloolFrameworkHelper frameworkBundle] pathForResource:@"coupons" ofType:@"plist"];
    NSData *plistData = [NSData dataWithContentsOfFile:path];
    NSString *error; NSPropertyListFormat format;
    NSArray *data = [NSPropertyListSerialization propertyListFromData:plistData
                                                     mutabilityOption:NSPropertyListImmutable
                                                               format:&format
                                                     errorDescription:&error];
    
    if (data != nil & [data count] > 0) {
        coupons = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for (int i=0; i<[data count]; i++) {
            NSDictionary *cd = [data objectAtIndex:i];
            NSString *name = [cd valueForKey:@"name"];
            ttCoupon *ttc = [ttCoupon initWithName:name context:context];
            [coupons insertObject:ttc atIndex:i];
        }
    }
    
    return coupons;
}


// Some dummy data (thrift format)
+ (NSMutableArray *)getData:(NSManagedObjectContext *)context
{
    static NSArray *_data;
    static NSMutableArray *_merchs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[TaloolFrameworkHelper frameworkBundle] pathForResource:@"merchants" ofType:@"plist"];
        NSData *plistData = [NSData dataWithContentsOfFile:path];
        NSString *error;
        NSPropertyListFormat format;
        _data = [NSPropertyListSerialization propertyListFromData:plistData
                                                 mutabilityOption:NSPropertyListImmutable
                                                           format:&format
                                                 errorDescription:&error];
        
        _merchs = [[NSMutableArray alloc] initWithCapacity:[_data count]];
        for (int i=0; i<[_data count]; i++) {
            ttMerchant *m = [ttMerchant initWithThrift:nil context:context];
            NSDictionary *d = [_data objectAtIndex:i];
            m.name = [d objectForKey:@"name"];
            m.email = @"doug@talool.com";
            [_merchs insertObject:m atIndex:i];
        }
         
    });
    
    return _merchs;
}



@end