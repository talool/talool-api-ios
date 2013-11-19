//
//  ttGiftDetail.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 11/19/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttGiftDetail.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttGiftDetail

+ (ttGiftDetail *)initWithThrift: (GiftDetail_t *)detail context:(NSManagedObjectContext *)context
{
    ttGiftDetail *giftDetail = [ttGiftDetail fetchById:detail.giftId
                                               context:context];
    
    giftDetail.toEmail = detail.toEmail;
    giftDetail.fromEmail = detail.fromEmail;
    giftDetail.toName = detail.toName;
    giftDetail.fromName = detail.fromName;
    giftDetail.giftId = detail.giftId;
    giftDetail.giftedTime = [NSDate dateWithTimeIntervalSince1970:(detail.giftedTime/1000)];
    
    return giftDetail;
}

+ (ttGiftDetail *) fetchById:(NSString *)entityId context:(NSManagedObjectContext *)context
{
    ttGiftDetail *detail = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.giftId = %@",entityId];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:GIFT_DETAIL_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    
    if (fetchedObj == nil || [fetchedObj count] == 0)
    {
        detail = (ttGiftDetail *)[NSEntityDescription
                                            insertNewObjectForEntityForName:GIFT_DETAIL_ENTITY_NAME
                                            inManagedObjectContext:context];
    }
    else
    {
        detail = [fetchedObj objectAtIndex:0];
    }
    return detail;
}

@end
