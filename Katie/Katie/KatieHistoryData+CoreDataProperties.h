//
//  KatieHistoryData+CoreDataProperties.h
//  
//
//  Created by manabu shimada on 31/01/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "KatieHistoryData.h"

NS_ASSUME_NONNULL_BEGIN

@interface KatieHistoryData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *carrier;
@property (nullable, nonatomic, retain) NSDate *calledAt;
@property (nullable, nonatomic, retain) NSString *carrierColor;
@property (nullable, nonatomic, retain) NSString *contactNameCalled;
@property (nullable, nonatomic, retain) NSString *dummyCarrier;
@property (nullable, nonatomic, retain) NSString *phoneNumberCalled;
@property (nullable, nonatomic, retain) NSString *phoneNumberReceived;
@property (nullable, nonatomic, retain) NSDate *receivedAt;
@property (nullable, nonatomic, retain) NSData *phoneNumbers;

@end

NS_ASSUME_NONNULL_END
