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
#import "ttDeal.h"
#import "TaloolFrameworkHelper.h"


@implementation MerchantController

@synthesize merchants;


- (id)init {
	if ((self = [super init])) {
		// do something cool
	}
	return self;
}

- (unsigned)countOfMerchants {
    return [merchants count];
}

- (id)objectInMerchantsAtIndex:(unsigned)theIndex {
    return [merchants objectAtIndex:theIndex];
}


@end