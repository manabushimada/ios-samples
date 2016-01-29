//
//  KatieColor.m
//  Katie
//
//  Created by manabu shimada on 24/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import "KatieColor.h"

@implementation KatieColor

+ (UIColor *)yvesKleinBlue
{
    return [self colorWithHex:@"002EA7"];
}

+ (UIColor *)katieColorPickerWithIndex:(NSUInteger)index
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KatieServices" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *colorArray = [NSArray arrayWithArray:[dic objectForKey:@"CarrierColorPicker"]];
    NSUInteger newIndex = index % colorArray.count;
    NSDictionary *color = colorArray[newIndex];
    UIColor *katieColor = [UIColor colorWithHex:color[@"Color"]]?[UIColor colorWithHex:color[@"Color"]]:[UIColor clearColor];
    return katieColor;
}



@end
