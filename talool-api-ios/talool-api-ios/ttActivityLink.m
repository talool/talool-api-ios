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
    ttActivityLink *a = (ttActivityLink *)[NSEntityDescription
                                   insertNewObjectForEntityForName:ACTIVITY_LINK_ENTITY_NAME
                                   inManagedObjectContext:context];
    
    a.linkType = [NSNumber numberWithInt:link.linkType];
    a.elementId = link.linkElement;
    
    return a;
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

@end
