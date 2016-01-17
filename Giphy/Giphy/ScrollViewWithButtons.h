//
//  ScrollViewWithButtons.h
//  BlackSwanFeverApp
//
//  Created by manabu shimada on 13/01/2016.
//  Copyright © 2016 Asio Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollViewWithButtonsDelegate <NSObject>

- (void)buttonInScrollViewTapped:(id)sender;

@end

@interface ScrollViewWithButtons : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, assign) id <ScrollViewWithButtonsDelegate> delegateClass;
- (void)buttonInChirpScrollViewPressed:(id)sender;

- (NSArray *)createScrollViewWithButtons:(NSArray *)array
                                     selector:(SEL)sel;

@end
