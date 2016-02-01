//
//  CarrierInfoTableViewCell.m
//  Katie
//
//  Created by manabu shimada on 31/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import "CarrierInfoTableViewCell.h"

#import "UIColor+Hex.h"

@implementation CarrierInfoTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.carrierLabel.adjustsFontSizeToFitWidth = YES;
}


- (void)updateWithDictionary:(NSDictionary *)dictinary
{
    NSString *carrier = dictinary[@"Carrier"];
    self.carrierLabel.text = carrier;

    NSString *hex = dictinary[@"Hex"];
    self.backgroundColor = [UIColor colorWithHex:hex];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
