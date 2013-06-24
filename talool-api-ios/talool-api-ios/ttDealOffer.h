//
//  ttDealOffer.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 5/15/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "TaloolDealOffer.h"

@class DealOffer_t, ttCustomer;

@interface ttDealOffer : TaloolDealOffer

+ (ttDealOffer *)initWithThrift: (DealOffer_t *)offer context:(NSManagedObjectContext *)context;
+ (ttDealOffer *)getDealOffer:(NSString *)doId
                     customer:(ttCustomer *)customer
                      context:(NSManagedObjectContext *)context
                        error:(NSError **)err;
+ (NSArray *)getDealOffers:(ttCustomer *)customer
                   context:(NSManagedObjectContext *)context
                     error:(NSError **)err;
- (DealOffer_t *)hydrateThriftObject;
- (NSArray *)getDeals:(ttCustomer *)customer
              context:(NSManagedObjectContext *)context
                error:(NSError **)err;

@end
