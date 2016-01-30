//
//  KatieNetworkRequest.m
//  Katie
//
//  Created by manabu shimada on 27/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import "KatieNetworkRequest.h"

#import "KatieAppConstants.h"

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
         NSLog(@"JSON: %@", responseObject);
         self.lookupData = responseObject;
     }
         failure:^(NSURLSessionTask *operation, NSError *error)
     {
         // Carrier is "Unknow"
         NSLog(@"Error: %@", error);
     }];
}



@end
