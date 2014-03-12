//
//  ttActivityLink.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 6/26/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttActivityLink.h"
#import "Activity.h"
#import "TaloolPersistentStoreCoordinator.h"

@implementation ttActivityLink

+ (ttActivityLink *)initWithThrift: (ActivityLink_t *)link context:(NSManagedObjectContext *)context
{
    ttActivityLink *a = [ttActivityLink fetchByLink:link context:context];
    
    a.linkType = [NSNumber numberWithInt:link.linkType];
    a.elementId = link.linkElement;
    
    return a;
}

+ (ttActivityLink *) fetchByLink:(ActivityLink_t *)lt context:(NSManagedObjectContext *)context
{
    ttActivityLink *link = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.elementId = %@ AND SELF.linkType = %@",lt.linkElement,
                         [NSNumber numberWithInt:lt.linkType]];
    [request setPredicate:pred];
    NSEntityDescription *entity = [NSEntityDescription entityForName:ACTIVITY_LINK_ENTITY_NAME inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObj = [context executeFetchRequest:request error:&error];
    
    if (fetchedObj == nil || [fetchedObj count] == 0)
    {
        link = (ttActivityLink *)[NSEntityDescription
                                  insertNewObjectForEntityForName:ACTIVITY_LINK_ENTITY_NAME
                                  inManagedObjectContext:context];
    }
    else
    {
        link = [fetchedObj objectAtIndex:0];
    }
    return link;
}

- (BOOL) isMerchantLink
{
    return ([self.linkType intValue] == LinkType_MERCHANT);
}
- (BOOL) isDealLink
{
    return ([self.linkType intValue] == LinkType_DEAL);
}
- (BOOL) isDealOfferLink{
    return ([self.linkType intValue] == LinkType_DEAL_OFFER);
}
- (BOOL) isGiftLink{
    return ([self.linkType intValue] == LinkType_GIFT);
}
- (BOOL) isCustomerLink{
    return ([self.linkType intValue] == LinkType_CUSTOMER);
}
- (BOOL) isDealAcquireLink{
    return ([self.linkType intValue] == LinkType_DEAL_ACQUIRE);
}
- (BOOL) isExternalLink{
    return ([self.linkType intValue] == LinkType_EXTERNAL);
}
- (BOOL) isMerchantLocationLink{
    return ([self.linkType intValue] == LinkType_MERCHANT_LOCATION);
}
- (BOOL) isEmailLink {
    return NO;
#warning "integrate new email link type"
}

@end
