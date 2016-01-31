//
//  DataManager.h
//  Katie
//
//  Created by manabu shimada on 25/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KatieAddressData.h"

@interface KatieDataManager : NSObject

+ (KatieDataManager *)sharedManager;

@property (strong) NSManagedObjectContext *managedObjectContext;
- (void)initializeCoreData;

+ (BOOL) save;
+ (KatieAddressData *)newAddressData;

+ (void)registerMyContacts:(NSArray *)contacts;
+ (KatieAddressData *)searchKatieAddressDataForPhoneNumber:(NSString *)phoneNumber;
+ (KatieAddressData *)searchKatieAddressDataForContactName:(NSString *)contactName;
+ (KatieAddressData *)searchKatieAddressDataForMyName:(NSString *)myName;
+ (KatieAddressData *)searchUnsavedKatieAddressDataForContactName:(NSString *)contactName;

+ (void)deleteAddressData:(KatieAddressData *)addressData;
+ (void)deleteAllAddressData;
+ (NSArray *) allAddressData;

@end
