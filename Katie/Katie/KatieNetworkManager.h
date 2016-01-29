//
//  KatieNetworkManager.h
//  Katie
//
//  Created by manabu shimada on 27/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KatieNetworkManager : NSObject

+ (KatieNetworkManager *) sharedManager;
+ (NSDictionary *)randomCarrier;

@end
