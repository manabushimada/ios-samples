//
//  KatieNetworkRequest.m
//  Katie
//
//  Created by manabu shimada on 27/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import "KatieNetworkRequest.h"
#import "KatieNetworkManager.h"

@implementation KatieNetworkRequest


#pragma mark - Authorization

+ (NSString *)authorizationString:(NSString *)accountSID withAuthToken:(NSString *)authToken
{
    if (!accountSID && !authToken)
    {
        return nil;
    }
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", accountSID, authToken];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authDataString = [authData base64EncodedStringWithOptions:0];
    return [NSString stringWithFormat:@"Basic %@", authDataString];
}

- (void)queryLookupAPIByPhoneNumber:(NSString *)phoneNumber
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:kTwilioLookupAccountSidKey password:kTwilioLookupAuthTokenKey];
    [manager GET:[NSString stringWithFormat:@"%@%@",kTwilioLookupResourceURL, phoneNumber] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"JSON: %@ ", responseObject);
         [self registerLookupJSONResponse:responseObject];
     }
         failure:^(NSURLSessionTask *operation, NSError *error)
     {
         // TODO: Nonexisting number is "Unknow" filtered by numberOfErrors value
         //[self registerLookupErrorJSONRessponces];
         NSLog(@"Error: %@", error);
     }];
}

- (void)registerLookupJSONResponse:(NSDictionary *)data
{
    NSLog(@"address data %@ dummy %@", self.addressData.phoneNumber, self.addressData.dummyCarrier);
    if (self.addressData)
    {
        if (!self.addressData.dummyCarrier)
        {
            [self.addressData setDummyCarrier:[KatieNetworkManager randomCarrier]];
            [self.addressData setNationalFormat:data[kTwilioLookupNationalFormatKey]];
            [self.addressData setCarrierColor:[KatieNetworkManager carrierColorHex:self.addressData.dummyCarrier]];
            [self.addressData setUrl:data[kTwilioLookupUrlKey]];
            [KatieDataManager save];
        }
    }
}

- (void)katieAddressDataForContactName:(NSString *)contactName
{
    if (contactName)
    {
        self.addressData = [KatieDataManager searchUnsavedKatieAddressDataForContactName:contactName];
        //NSLog(@"original address data %@", self.addressData);
    }
}

- (void)registerLookupErrorJSONRessponces
{
    if (self.addressData)
    {
        if (!self.addressData.dummyCarrier)
        {
            [self.addressData setDummyCarrier:@"Unknown"]; // Hex a5a5a5
            [self.addressData setCarrierColor:@"a5a5a5"];
            [KatieDataManager save];
        }
    }
}

@end
