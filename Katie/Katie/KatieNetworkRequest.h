//
//  KatieNetworkRequest.h
//  Katie
//
//  Created by manabu shimada on 27/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>

typedef enum
{
    LookupRequestMethodGET,
    LookupRequestMethodPOST,
    LookupRequestMethodPUT,
    LookupRequestMethodDELETE
} LookupRequestMethod;

@interface KatieNetworkRequest : NSObject

@property (nonatomic, strong) NSDictionary *lookupData;

+ (NSString *)authorizationString:(NSString *)accountSID withAuthToken:(NSString *)authToken;

- (void)queryLookupAPIByPhoneNumber:(NSString *)phoneNumber;

@end
