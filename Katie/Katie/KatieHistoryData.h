//
//  KatieHistoryData.h
//  
//
//  Created by manabu shimada on 31/01/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface KatieHistoryData : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (NSDictionary *)dictionaryRepresentation;

@end

NS_ASSUME_NONNULL_END

#import "KatieHistoryData+CoreDataProperties.h"
