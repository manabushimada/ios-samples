//
//  KatieAddressData+CoreDataProperties.h
//  
//
//  Created by manabu shimada on 29/01/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "KatieAddressData.h"

NS_ASSUME_NONNULL_BEGIN

@interface KatieAddressData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *calledAt;
@property (nullable, nonatomic, retain) NSString *carrier;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSNumber *favourite;
@property (nullable, nonatomic, retain) NSString *mobileNumberCalled;
@property (nullable, nonatomic, retain) NSData *mobileNumbers;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDate *receivedAt;
@property (nullable, nonatomic, retain) NSString *myName;
@property (nullable, nonatomic, retain) NSData *myPhoneNumber;
@property (nullable, nonatomic, retain) NSString *myCarrier;

@end

NS_ASSUME_NONNULL_END
