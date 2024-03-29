//
//  SocialNetworkDetail.h
//  talool-api-ios
//
//  Created by Douglas McCuen on 4/24/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SocialNetworkDetail : NSManagedObject

@property (nonatomic, retain) NSString * apiUlr;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * socialNetwork;
@property (nonatomic, retain) NSString * website;

@end
