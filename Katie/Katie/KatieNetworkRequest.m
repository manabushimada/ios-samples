//
//  KatieNetworkRequest.m
//  Katie
//
//  Created by manabu shimada on 27/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import "KatieNetworkRequest.h"

@implementation KatieNetworkRequest


- (void)queryLookupAPI:(NSUInteger)phoneNumber
{
    /**
    NSString *urlAsString = [NSString stringWithFormat:@"https://lookups.twilio.com/v1/PhoneNumbers/+819021668768", coordinate.latitude, coordinate.longitude, PAGE_COUNT, API_KEY];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self.delegate fetchingLookupFailedWithError:error];
        } else {
            [self.delegate receivedLookupJSON:data];
        }
    }];
     */
}


@end
