//
//  GiphyCollectionViewCell.m
//  BlackSwanFeverApp
//
//  Created by manabu shimada on 13/01/2016.
//  Copyright © 2016 Asio Ltd. All rights reserved.
//

#import "GiphyCollectionViewCell.h"

@implementation GiphyCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.giphyImageView.image = nil;
        self.giphyImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.giphyImageView.contentMode = UIViewContentModeScaleToFill;
        self.giphyImageView.clipsToBounds = YES;
        
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.giphyImageView.image = nil;
    [self.indicator setHidden:YES];
}

- (void)startActiveIndicator
{
    [self.indicator startAnimating];
}

- (void)stopActiveIndicator
{
    [self.indicator stopAnimating];
}


@end
