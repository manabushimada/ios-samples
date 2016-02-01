//
//  HistoryViewController.m
//  Katie
//
//  Created by manabu shimada on 31/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import "HistoryViewController.h"

#import "KatieAppConstants.h"

@interface HistoryViewController ()

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    /*----------------------------------------------------------------------------*
     * Instantiate the fetchedResultsController
     *----------------------------------------------------------------------------*/
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }

    [self.historyTableView setBackgroundColor:[UIColor clearColor]];
    self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /*----------------------------------------------------------------------------*
     * Setup my tableView settings
     *----------------------------------------------------------------------------*/
    [self.historyTableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HistoryCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.historyTableView reloadData];

}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!tableView.isEditing)
    {
        // About to Call this number
        KatieHistoryData *historyData =  self.fetchedResultsController.fetchedObjects[indexPath.row];        
        [self callPhoneNumber:[NSString stringByRemovingSpaces:historyData.phoneNumberCalled]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.fetchedResultsController.fetchedObjects.count)
    {
        [self.noHistoriesLabel setHidden:YES];
        return self.fetchedResultsController.fetchedObjects.count;
    }
    else
    {
        [self.noHistoriesLabel setHidden:NO];
        return 0;
    }
}

- (HistoryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HistoryCell";
    HistoryTableViewCell *cell = [self.historyTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    [cell updateWithHistoryData:self.fetchedResultsController.fetchedObjects[indexPath.row]];
    
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tableViewArray;
    
    if (indexPath.section == 0)
    {
        UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                          title:@"Delete"
                                                                        handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                            KatieHistoryData *historyData = self.fetchedResultsController.fetchedObjects[indexPath.row];
                                                                            [KatieDataManager deleteHistoryData:historyData];
                                                                        }];
        tableViewArray =  @[delete];
    }
    
    return tableViewArray;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Do nothing, stay here, otherwise the editActionsForRowAtIndexPath won't work.
}

#pragma mark - Actions

- (void)callPhoneNumber:(NSString *)phoneNumber
{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phoneNumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
    {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}

#pragma mark - Setups
- (void)setupNavigationItem
{
    // Set NavigationItem label configuration
    self.navigationController.navigationBar.topItem.title = @"History";
    self.navigationController.navigationBar.titleTextAttributes =
    @{NSForegroundColorAttributeName : [KatieColor yvesKleinBlue], NSFontAttributeName : [KatieFonts katieFontNavigationItem]};
}

#pragma mark - NSFetchedResultsController Delegate

- (NSFetchedResultsController *)fetchedResultsController
{
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"KatieHistoryData" inManagedObjectContext:[KatieDataManager sharedManager].managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *calledAtOrder = [[NSSortDescriptor alloc]
                                       initWithKey:@"calledAt" ascending:NO];
    [fetchRequest setSortDescriptors:@[calledAtOrder]];
    [fetchRequest setFetchBatchSize:10];
    
    [NSFetchedResultsController deleteCacheWithName:@"KatieHistoryData"];
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[KatieDataManager sharedManager].managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"KatieAddressData"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (!newIndexPath) {
        return;
    }

     switch (type)
     {
     case NSFetchedResultsChangeInsert: // Called when inserting a new data into CoreData
     [self.historyTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newIndexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
     break;
     case NSFetchedResultsChangeDelete: // Called when deleting it
     [self.historyTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newIndexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
     break;
     
     default:
     break;
     }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // Called as soon as data is changed.
    [self.historyTableView endUpdates];
    [self.historyTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
