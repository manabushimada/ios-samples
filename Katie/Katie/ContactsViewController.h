//
//  ViewController.h
//  Katie
//
//  Created by manabu shimada on 24/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "KatieNetworkManager.h"

@interface ContactsViewController : UIViewController
<UITableViewDelegate,
UITableViewDataSource,
NSFetchedResultsControllerDelegate,
UISearchBarDelegate,
UISearchDisplayDelegate,
UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) KatieAddressData *addressDataCalled;

@end

