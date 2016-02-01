//
//  UIColor+Hex.h
//  ChirpNoisyBird
//
//  Created by manabu shimada on 01/12/2014.
//  Copyright (c) 2014 Chirp. All rights reserved.
//

#import <UIKit/UIKit.h>




/*----------------------------------------------------------------------------*
 * UIColor Hex convertor.
 * Reference: http://dev.classmethod.jp/smartphone/ios-tips-2/
 *----------------------------------------------------------------------------*/

@interface UIColor (Hex)

/**
 Convert from RGB to UIColor
 
 @param     colorCode  RGB
 @return    UIColor instance
 */
+ (UIColor *)colorWithHex:(NSString *)colorCode;

/**
 Convert from RGB with alpha to UIColor
 
 @param     colorCode   RGB
 @param     alpha       Alpha
 @return    UIColor instance
 */

+ (UIColor *)colorWithHex:(NSString *)colorCode alpha:(CGFloat)alpha;


@end
