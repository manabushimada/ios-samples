//
//  HistoryTableViewCell.m
//  Katie
//
//  Created by manabu shimada on 31/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import "HistoryTableViewCell.h"

#import "UIColor+Hex.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.contactNameCalledLabel.adjustsFontSizeToFitWidth = YES;
    self.backgroundColor = [UIColor clearColor];
}

- (void)updateWithHistoryData:(KatieHistoryData *)historyData
{
    self.contactNameCalledLabel.text = historyData.contactNameCalled;
    self.phoneNumberCalledLabel.text = historyData.phoneNumberCalled;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:historyData.calledAt];
    self.calledAtLabel.text = dateString;
    
    self.backgroundColor = [UIColor colorWithHex:historyData.carrierColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
