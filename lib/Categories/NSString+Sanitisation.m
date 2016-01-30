//
//  NSString+Sanitisation.m
//  Katie
//
//  Created by manabu shimada on 28/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import "NSString+Sanitisation.h"

@implementation NSString (Sanitisation)

+ (NSString *)stringByRemovingSpaces:(NSString *)string
{
    [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *words = [string componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *noSpaceString = [words componentsJoinedByString:@""];
    
    return noSpaceString;
}

+ (NSString *)stringByRemovingAlphabets:(NSString *)string
{
    if ([string rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location == NSNotFound)
    {
        return string;
    }
    return @"unknow phone number";
}

+ (BOOL)isStringContainingCountryCode:(NSString *)string
{
    if ([[string substringToIndex:1] isEqualToString:@"+"])
    {
        return YES;
    }
    
    return NO;
}

@end
