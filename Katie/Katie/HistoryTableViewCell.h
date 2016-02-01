//
//  HistoryTableViewCell.h
//  Katie
//
//  Created by manabu shimada on 31/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KatieHistoryData.h"

@interface HistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contactNameCalledLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberCalledLabel;
@property (weak, nonatomic) IBOutlet UILabel *calledAtLabel;

- (void)updateWithHistoryData:(KatieHistoryData *)historyData;

@end
