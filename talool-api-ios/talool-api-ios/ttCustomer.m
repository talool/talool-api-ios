//
//  ttCustomer.m
//  talool-api-ios
//
//  Created by Douglas McCuen on 3/13/13.
//  Copyright (c) 2013 Douglas McCuen. All rights reserved.
//

#import "ttCustomer.h"
#import "ttSocialAccount.h"
#import "Core.h"
#import "TaloolPersistentStoreCoordinator.h"
#import "MerchantController.h"
#import "CustomerController.h"


@implementation ttCustomer

@synthesize thrift;

-(BOOL)isValid:(NSError *__autoreleasing *)error
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    if (self.firstName == nil || self.firstName.length < 2) {
        [details setValue:@"Your first name is invalid" forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"customerValidation" code:200 userInfo:details];
        return NO;
    } else if (self.lastName == nil || self.lastName.length < 2) {
        [details setValue:@"Your last name is invalid" forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"customerValidation" code:200 userInfo:details];
        return NO;
    } else if (self.email == nil || self.email.length < 2) {
        [details setValue:@"Your email is invalid" forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"customerValidation" code:200 userInfo:details];
        return NO;
    }
    return YES;
}

+(ttCustomer *)initWithThrift:(Customer_t *)c context:(NSManagedObjectContext *)context
{
    ttCustomer *customer = (ttCustomer *)[NSEntityDescription
                                          insertNewObjectForEntityForName:CUSTOMER_ENTITY_NAME
                                          inManagedObjectContext:context];
    customer.firstName = c.firstName;
    customer.lastName = c.lastName;
    customer.email = c.email;
    customer.sex = [[NSNumber alloc] initWithInt:c.sex];
    customer.customerId = c.customerId;
    
    if (c.socialAccountsIsSet) {
        NSMutableArray *keys = [[NSMutableArray alloc] initWithArray:[c.socialAccounts allKeys]];
        for (int i=0; i<[keys count]; i++) {
            
            NSNumber *key = [[NSNumber alloc] initWithInt:(int)[keys objectAtIndex:i]];
            SocialAccount_t *sat = [c.socialAccounts objectForKey:key];
            ttSocialAccount *sa = [ttSocialAccount initWithThrift:sat context:context];
            [customer addSocialAccountsObject:sa];
        }
    }
    
    // TODO it may be better to persist the thrift object and update individual properties
    customer.thrift = c;
    
    return customer;
}

-(Customer_t *)hydrateThriftObject
{
    Customer_t *customer = [[Customer_t alloc] init];
    customer.firstName = self.firstName;
    customer.lastName = self.lastName;
    customer.email = self.email;
    customer.sex = [self.sex integerValue];

    customer.customerId = self.customerId;
    
    NSEnumerator *enumerator = [self.socialAccounts objectEnumerator];
    ttSocialAccount *sa;
    SocialAccount_t *sat;
    while (sa = [enumerator nextObject]) {
        sat = [sa hydrateThriftObject];
        [customer.socialAccounts setObject:sat forKey:[[NSNumber alloc] initWithInt:SocialNetwork_t_Facebook]];
    }
    
    return customer;
}

-(NSString *) getFullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

-(ttToken *) getTaloolToken
{
    return (ttToken *)self.token;
}

- (void) refreshMerchants: (NSManagedObjectContext *)context
{
    [self removeMerchants:self.merchants];
    
    CustomerController *cc = [[CustomerController alloc] init];
    NSError *error = [NSError alloc];
    NSMutableArray *merchants = [cc getMerchants:self context:context error:&error];
    NSSet *fMerchants = [[NSSet alloc] initWithArray:merchants];
    
    [self addMerchants:fMerchants];

}

@end
