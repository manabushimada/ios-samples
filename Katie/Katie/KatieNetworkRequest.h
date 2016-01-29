//
//  KatieNetworkRequest.h
//  Katie
//
//  Created by manabu shimada on 27/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KatieNetworkRequestDelegate
- (void)receivedLookupJSON:(NSData *)objectNotation;
- (void)fetchingLookupFailedWithError:(NSError *)error;
@end

@interface KatieNetworkRequest : NSObject

@property (weak, nonatomic) id<KatieNetworkRequestDelegate> delegate;

//- (void)searchGroupsAtCoordinate:(CLLocationCoordinate2D)coordinate;

@end
