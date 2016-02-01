//
//  DataManager.h
//  Katie
//
//  Created by manabu shimada on 25/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KatieAddressData.h"
#import "KatieHistoryData.h"

@interface KatieDataManager : NSObject

+ (KatieDataManager *)sharedManager;

@property (strong) NSManagedObjectContext *managedObjectContext;
- (void)initializeCoreData;

+ (BOOL) save;
+ (KatieAddressData *)newAddressData;
+ (KatieHistoryData *)newHistoryData;

+ (void)registerMyContacts:(NSArray *)contacts;
+ (KatieAddressData *)katieAddressDataForPhoneNumber:(NSString *)phoneNumber;
+ (KatieAddressData *)katieAddressDataForContactName:(NSString *)contactName;
+ (KatieAddressData *)katieAddressDataForMyName:(NSString *)myName;
+ (KatieAddressData *)searchUnsavedKatieAddressDataForContactName:(NSString *)contactName;

+ (void)deleteAddressData:(KatieAddressData *)addressData;
+ (void)deleteAllAddressData;
+ (NSArray *) allAddressData;

+ (void)deleteHistoryData:(KatieHistoryData *)historyData;
+ (NSArray *) allHistoryData;

@end
