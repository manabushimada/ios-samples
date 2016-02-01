//
//  KatieNetworkRequest.h
//  Katie
//
//  Created by manabu shimada on 27/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>
#import "KatieDataManager.h"
#import "KatieAppConstants.h"

@interface KatieNetworkRequest : NSObject

@property (nonatomic, strong) KatieAddressData *addressData;


- (void)queryLookupAPIByPhoneNumber:(NSString *)phoneNumber;
- (void)katieAddressDataForContactName:(NSString *)contactName;

@end
