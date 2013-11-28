//
//  DealAcquireController.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/27/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolThriftController.h"

@class ttCustomer, ttDealAcquire, ttMerchant;

@interface DealAcquireController : TaloolThriftController

- (NSMutableArray *) getAcquiredDeals:(ttMerchant *)merchant forCustomer:(ttCustomer *)customer error:(NSError**)error;
- (NSString *) redeem:(ttDealAcquire *)dealAcquire
          forCustomer:(ttCustomer *)customer
             latitude:(double)latitude
            longitude:(double)longitude
                error:(NSError**)error;



@end
