//
//  KatieAddressData+CoreDataProperties.h
//  
//
//  Created by manabu shimada on 30/01/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "KatieAddressData.h"

NS_ASSUME_NONNULL_BEGIN

@interface KatieAddressData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *calledAt;
@property (nullable, nonatomic, retain) NSString *dummyCarrier;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSNumber *favourite;
@property (nullable, nonatomic, retain) NSString *phoneNumberCalled;
@property (nullable, nonatomic, retain) NSData *phoneNumbers;
@property (nullable, nonatomic, retain) NSString *myCarrier;
@property (nullable, nonatomic, retain) NSString *myName;
@property (nullable, nonatomic, retain) NSString *myPhoneNumber;
@property (nullable, nonatomic, retain) NSString *contactName;
@property (nullable, nonatomic, retain) NSDate *receivedAt;
@property (nullable, nonatomic, retain) NSData *carrier;
@property (nullable, nonatomic, retain) NSString *countryCode;
@property (nullable, nonatomic, retain) NSString *nationalFormat;
@property (nullable, nonatomic, retain) NSString *phoneNumber;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *carrierColor;

@end

NS_ASSUME_NONNULL_END
