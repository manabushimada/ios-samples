//
//  HistoryViewController.h
//  Katie
//
//  Created by manabu shimada on 31/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "HistoryTableViewCell.h"
#import "KatieDataManager.h"
#import "KatieFonts.h"
#import "KatieColor.h"
#import "NSString+Sanitisation.h"

@interface HistoryViewController : UIViewController
<UITableViewDelegate,
UITableViewDataSource,
NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *noHistoriesLabel;
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

@end
