//
//  ScrollViewWithButtons.m
//  BlackSwanFeverApp
//
//  Created by manabu shimada on 13/01/2016.
//  Copyright © 2016 Asio Ltd. All rights reserved.
//

#import "ScrollViewWithButtons.h"

NSString * const kCategoriesButtonFontFace = @"HelveticaNeue-Bold";
const CGFloat kCategoriesButtonFontSize = 14;

@implementation ScrollViewWithButtons

@synthesize delegateClass;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (NSArray *)createScrollViewWithButtons:(NSArray *)array
                                     selector:(SEL)sel
{
    NSMutableArray *buttonsArray = [NSMutableArray new];
    CGFloat contentWidth = 0.0;
    
    NSArray *titleArray = array;
    
    for (int i = 0; i < [titleArray count]; i++)
    {
        /*----------------------------------------------------------------------------*
         * Create Square buttons.
         *----------------------------------------------------------------------------*/
        UIButton *buttons = [UIButton new];
        
        UIFont *font = [UIFont fontWithName:kCategoriesButtonFontFace size:kCategoriesButtonFontSize];
        [buttons.titleLabel setFont:font];
        [buttons setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        buttons.highlighted = YES;
        
        
        [buttons setTitle:titleArray[i] forState:UIControlStateNormal];
        
        CGSize size = [titleArray[i] sizeWithAttributes:@{NSFontAttributeName:font}];
        const CGFloat padding = 24;
        buttons.frame = CGRectMake(contentWidth,
                                   self.bounds.origin.y,
                                   size.width + padding,
                                   self.frame.size.height);
        
        [buttons addTarget:self action: sel forControlEvents:UIControlEventTouchDown];
        buttons.backgroundColor = [UIColor whiteColor];
        buttons.layer.borderColor = [UIColor whiteColor].CGColor;
        buttons.layer.borderWidth = 2;
        buttons.tag = i;
        
        contentWidth += buttons.frame.size.width + 5;
        
        [self addSubview:buttons];
        [buttonsArray addObject:buttons];
    }
    
    CGRect contentRect = CGRectMake(0,
                                    0,
                                    contentWidth,
                                    self.frame.size.height);
    
    self.contentSize = contentRect.size;
    
    return buttonsArray;
}

#pragma mark - ScrollViewWithButtons delegateClass

- (void)buttonInChirpScrollViewPressed:(id)sender
{
    if ([self.delegateClass respondsToSelector:@selector(buttonInScrollViewTapped:)])
        [self.delegateClass buttonInScrollViewTapped:sender];
}


@end
