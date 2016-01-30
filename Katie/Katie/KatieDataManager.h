//
//  DataManager.h
//  Katie
//
//  Created by manabu shimada on 25/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KatieAddressData.h"
#import "KatieLookupData.h"

@interface KatieDataManager : NSObject

+ (KatieDataManager *)sharedManager;

@property (strong) NSManagedObjectContext *managedObjectContext;
- (void)initializeCoreData;

+ (BOOL) save;
+ (KatieAddressData *)newAddressData;
+ (KatieLookupData *)newLookupData;

+ (void)registerMyContacts:(NSArray *)contacts;
+ (KatieAddressData *)searchAddressDataForPhoneNumber:(NSString *)phoneNumber;
+ (KatieAddressData *)searchAddressDataForName:(NSString *)name;

@end
