//
//  MerchantController.h
//  mobile
//
//  Created by Douglas McCuen on 2/18/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "TaloolThriftController.h"

@class ttCustomer, ttCategory;

@interface MerchantController : TaloolThriftController


- (NSMutableArray *) getCategories:(ttCustomer *)customer error:(NSError**)error;

- (NSMutableArray *) getMerchants:(ttCustomer *)customer
                     withLocation:(CLLocation *)location
                            error:(NSError**)error;

- (NSMutableArray *) getFavoriteMerchants:(ttCustomer *)customer
                                    error:(NSError**)error;

- (BOOL) addFavoriteMerchant:(ttCustomer *)customer
                  merchantId:(NSString *)merchantId
                       error:(NSError**)error;

- (BOOL) removeFavoriteMerchant:(ttCustomer *)customer
                     merchantId:(NSString *)merchantId
                          error:(NSError**)error;


@end