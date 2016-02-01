//
//  ContactTableViewCell.h
//  Katie
//
//  Created by manabu shimada on 26/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <APContact.h>

@interface ContactTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *carrierLabel;

- (void)updateWithModel:(id)model;
- (void)searchContactByArrayWithName:(NSArray *)array name:(NSString *)name;

@end
