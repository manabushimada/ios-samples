//
//  KatieNetworkManager.m
//  Katie
//
//  Created by manabu shimada on 27/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import "KatieNetworkManager.h"

static KatieNetworkManager *_manager = nil;

@implementation KatieNetworkManager

+ (KatieNetworkManager *) sharedManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
                  {
                      if (!_manager)
                      {
                          _manager        = (KatieNetworkManager *) [KatieNetworkManager new];
                      }
                  });
    
    return _manager;
}

+ (NSDictionary *)randomCarrier
{
    /*----------------------------------------------------------------------------*
     * Lookup by Twilio is a paid service. 
     * The reason why I would like to use a plist instead of that service
     * in order to fetch a mobile carrier mapping each of your contacts.
     *----------------------------------------------------------------------------*/
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KatieServices" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *array = [NSArray arrayWithArray:[dic objectForKey:@"CarrierPicker"]];
    NSDictionary *dict = array[rand()%array.count];
    
    return dict;
}

@end
