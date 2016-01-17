//
//  GiphyCollectionViewCell.h
//  BlackSwanFeverApp
//
//  Created by manabu shimada on 13/01/2016.
//  Copyright © 2016 Asio Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

@interface GiphyCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *giphyImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

- (void)startActiveIndicator;
- (void)stopActiveIndicator;


@end
