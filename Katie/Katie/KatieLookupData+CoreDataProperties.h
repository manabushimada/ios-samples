//
//  KatieLookupData+CoreDataProperties.h
//  
//
//  Created by manabu shimada on 27/01/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "KatieLookupData.h"

NS_ASSUME_NONNULL_BEGIN

@interface KatieLookupData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *countryCode;
@property (nullable, nonatomic, retain) NSNumber *phoneNumber;
@property (nullable, nonatomic, retain) NSNumber *nationalFormat;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSData *carrier;

@end

NS_ASSUME_NONNULL_END
