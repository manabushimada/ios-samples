//
//  ViewController.h
//  Katie
//
//  Created by manabu shimada on 24/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <APAddressBook.h>
#import <APContact.h>

#import "ContactTableViewCell.h"
#import "KatieDataManager.h"
#import "KatieFonts.h"
#import "KatieColor.h"

#import "NSString+Sanitisation.h"

@interface ContactsViewController : UIViewController
<UITableViewDelegate,
UITableViewDataSource,
NSFetchedResultsControllerDelegate,
UISearchBarDelegate,
UISearchDisplayDelegate>


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

