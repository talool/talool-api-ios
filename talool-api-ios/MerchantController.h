//
//  MerchantController.h
//  mobile
//
//  Created by Douglas McCuen on 2/18/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ttMerchant;
@class ttCustomer;

@interface MerchantController : NSObject {
	NSMutableArray *merchants;
}

@property (nonatomic, readonly) NSMutableArray *merchants;

- (unsigned)countOfMerchants;
- (id)objectInMerchantsAtIndex:(unsigned)theIndex;


@end