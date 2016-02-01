//
//  CarrierInfoTableViewCell.h
//  Katie
//
//  Created by manabu shimada on 31/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarrierInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *carrierLabel;

- (void)updateWithDictionary:(NSDictionary *)dictinary;

@end
