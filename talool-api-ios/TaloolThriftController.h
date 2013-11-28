//
//  TaloolThriftController.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/27/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomerService_tClient,APIErrorManager, ttToken;

@interface TaloolThriftController : NSObject

@property (strong, nonatomic) CustomerService_tClient *service;
@property (strong, nonatomic) APIErrorManager *errorManager;

- (void)connect;
- (void)connectWithToken:(ttToken *)token;
- (void)disconnect;

@end
