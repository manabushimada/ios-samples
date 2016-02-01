//
//  KatieNetworkManager.h
//  Katie
//
//  Created by manabu shimada on 27/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KatieNetworkRequest.h"

@interface KatieNetworkManager : NSObject

+ (KatieNetworkManager *) sharedManager;
+ (NSString *)randomCarrier;
+ (NSDictionary *)randomCarrierDictionary;
+ (NSString *)carrierColorHex:(NSString *)carrier;
+ (NSArray *)carrierArrayInPlist;

- (void)getContactDataWithPhoneNumber:(NSString *)phoneNumber contactName:(NSString *)contactName;

@end
