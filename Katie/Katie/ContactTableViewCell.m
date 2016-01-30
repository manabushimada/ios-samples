//
//  ContactTableViewCell.m
//  Katie
//
//  Created by manabu shimada on 26/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import "ContactTableViewCell.h"

#import "KatieNetworkManager.h"
#import "KatieColor.h"
#import "NSString+Sanitisation.h"

@interface ContactTableViewCell ()
{
    NSMutableArray *namesData;
}

@end

@implementation ContactTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    // self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.name.adjustsFontSizeToFitWidth = YES;
    
}


- (void)updateWithModel:(id)model
{
    APContact *contact = model;
    self.name.text = [self contactName:contact];
    self.phoneNumber.text = [self contactPhones:contact];
    
    // TODO: Populate a random carrier into CoreData to make it constant value.
    NSDictionary *dict = [KatieNetworkManager randomCarrierWithHex];
    NSString *carrier = dict[@"Carrier"];
    NSString *hex = dict[@"Hex"];
    self.carrierLabel.text = carrier;
    self.backgroundColor = [UIColor colorWithHex:hex];
   
   // [[KatieNetworkManager sharedManager] queryLookupAPIByPhoneNumber:self.phoneNumber.text];
}

- (void)searchContactByArrayWithName:(NSArray *)array name:(NSString *)name
{
    for (APContact *contact in array)
    {
        if ([name isEqualToString:contact.name.compositeName])
        {
            [self updateWithModel:contact];
        }
    }
}

#pragma mark - private

- (NSString *)contactName:(APContact *)contact
{
    if (contact.name.compositeName)
    {
        return contact.name.compositeName;
    }
    else if (contact.name.firstName && contact.name.lastName)
    {
        return [NSString stringWithFormat:@"%@ %@", contact.name.firstName, contact.name.lastName];
    }
    else if (contact.name.firstName || contact.name.lastName)
    {
        return contact.name.firstName ?: contact.name.lastName;
    }
    else
    {
        return @"untitled contact";
    }
}

- (NSString *)contactPhones:(APContact *)contact
{
    if (contact.phones.count > 0)
    {
        NSMutableString *result = [[NSMutableString alloc] init];
        for (APPhone *phone in contact.phones)
        {
            NSString *string = phone.localizedLabel.length == 0 ? phone.number :
            [NSString stringWithFormat:@"%@", phone.number]; //phone.localizedLabel
            [result appendFormat:@"%@, ", string];
        }
        return result;
    }
    else
    {
        return @"(No phones)";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
