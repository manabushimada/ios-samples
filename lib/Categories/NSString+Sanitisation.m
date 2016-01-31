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

+ (NSString *)stringByAddingCountryCode:(NSString *)string
{
    if ([[string substringToIndex:1] isEqualToString:@"+"])
    {
        return string;
    }
    else if ([[string substringToIndex:2] isEqualToString:@"00"])
    {
        string = [string stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"+"];
        return string;
    }
    
    return string;
    
}

+ (NSString *)stringByReplacingPhoneNumber:(NSString *)string
{
    string = [self stringByRemovingSpaces:string];
    string = [self stringByAddingCountryCode:string];
    
    return string;
}

+ (BOOL)isStringContainingCountryCode:(NSString *)string
{
    if ([[string substringToIndex:1] isEqualToString:@"+"])
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isStringContainingMultibyteString:(NSString *)string
{
    if(![string canBeConvertedToEncoding:NSASCIIStringEncoding])
    {
        NSLog(@"string %@", string);
        return YES;
    }

    return NO;
}

@end
