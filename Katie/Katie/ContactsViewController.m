//
//  ViewController.m
//  Katie
//
//  Created by manabu shimada on 24/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import "ContactsViewController.h"

#import "KatieNetworkManager.h"
#import "KatieAppConstants.h"

@interface ContactsViewController ()
{
    NSArray *searchResults;
}

@property (nonatomic, strong) NSMutableArray *namesData;
@property (nonatomic, strong) NSMutableArray *phoneNumbersData;
@property (nonatomic, strong) NSMutableArray *apContact;
@property (nonatomic, strong) APAddressBook *addressBook;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationItem];
    [self setupRefreshControl];
    
    /*----------------------------------------------------------------------------*
     * Instantiate the fetchedResultsController
     *----------------------------------------------------------------------------*/
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    [self.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.namesData = [NSMutableArray new];
    self.phoneNumbersData = [NSMutableArray new];
    self.apContact = [NSMutableArray new];
    self.addressBook = [[APAddressBook alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.addressBook startObserveChangesWithCallback:^
     {
         [weakSelf loadContacts];
     }];
    [self loadContacts];
    
    
    if (self.fetchedResultsController.fetchedObjects.count == 0 && self.apContact.count == 0) {
            [KatieDataManager registerMyContacts:self.apContact];
    } else {
        for (int i = 0; i < self.fetchedResultsController.fetchedObjects.count; i++) {
            DLog(@"fetched data %@", self.fetchedResultsController.fetchedObjects[i]);
        }
    }
    
    //[[KatieNetworkManager sharedManager] queryLookupAPIByPhoneNumber:@"+447857242152"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    /*----------------------------------------------------------------------------*
     * Setup my tableView settings
     *----------------------------------------------------------------------------*/
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ContactCell"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [searchResults count];
    }
    else
    {
        if (self.apContact)
        {
            return self.apContact.count;
        }
        else
        {
            return 0;
        }
    }
}

- (ContactTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ContactCell";
    ContactTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [cell searchContactByArrayWithName:self.apContact name:searchResults[indexPath.row]];
    }
    else
    {
        [cell updateWithModel:self.apContact[indexPath.row]];
    }
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSDictionary *contactDetailsDictionary = [_arrContactsData objectAtIndex:self.tableView.indexPathForSelectedRow.row];
//        [[segue destinationViewController] setDictContactDetails:contactDetailsDictionary];
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!tableView.isEditing)
    {
        // About to Call this number
        NSString *phoneNumber = self.phoneNumbersData[indexPath.row];
        [self phoneCallButtonPressed:[NSString stringByRemovingSpaces:phoneNumber]];
    }
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    searchResults = [self.namesData filteredArrayUsingPredicate:resultPredicate];
}

#pragma mark - UISearchDisplayDelegate

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark - Privates

- (void)loadContacts
{
    // CTODO: lear all cells first
    //[self.apContact removeAllObjects];
    
    //[[KatieNeworkManager sharedManager] queryJSONFromLookup];
    [self.indicatorView startAnimating];
    __weak __typeof(self) weakSelf = self;
    self.addressBook.fieldsMask = APContactFieldAll;
    self.addressBook.sortDescriptors = @[
                                         [NSSortDescriptor sortDescriptorWithKey:@"name.firstName" ascending:YES],
                                         [NSSortDescriptor sortDescriptorWithKey:@"name.lastName" ascending:YES]];
    self.addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0;
    };
    
    [self.addressBook loadContacts:^(NSArray<APContact *> *contacts, NSError *error)
    {
        [weakSelf.indicatorView stopAnimating];
        if (contacts)
        {
            for (APContact *contact in contacts)
            {
                // Store APContact objects
                [weakSelf.apContact addObject:contact];
                
                [weakSelf.namesData addObject:contact.name.compositeName?contact.name.compositeName:@"untitled contact"];
                [weakSelf.phoneNumbersData addObject:contact.phones[0].number];
            }
            
            [self queryLookupAPIWithPhoneNumbers:weakSelf.phoneNumbersData];
            [weakSelf.tableView reloadData];
        }
        else if (error)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }];
}


- (void)queryLookupAPIWithPhoneNumbers:(NSArray *)phoneNumbers
{
    dispatch_group_t dispatchGroup = dispatch_group_create();
    for (int i = 0; i < self.phoneNumbersData.count; i++) {
        dispatch_group_enter(dispatchGroup);
        NSString *newPhoneNumber = [NSString stringByRemovingAlphabets:phoneNumbers[i]];
        if (![newPhoneNumber isEqualToString:kKatieUnknowPhoneNumber])
        {
            if ([NSString isStringContainingCountryCode:newPhoneNumber])
            {
                // Ensure phone number must constain country code itself.
                NSLog(@"number %@", [NSString stringByRemovingSpaces:newPhoneNumber]);
                [[KatieNetworkManager sharedManager] getContactDataWithPhoneNumber:[NSString stringByRemovingSpaces:newPhoneNumber]];
            }
            else
            {
                // unknown carrier
            }
        }
        
    }
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
        // update UI here
    });
}

#pragma mark - Setups

- (void)setupRefreshControl
{
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadTableView)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
}

- (void)setupNavigationItem
{
    // Set NavigationItem label configuration
    self.navigationController.navigationBar.topItem.title = @"Contacts";
    self.navigationController.navigationBar.titleTextAttributes =
  @{NSForegroundColorAttributeName : [KatieColor yvesKleinBlue], NSFontAttributeName : [KatieFonts katieFontNavigationItem]};
}

#pragma mark - Actions

- (void)phoneCallButtonPressed:(NSString *)phoneNumber
{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phoneNumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
    {
        [[UIApplication sharedApplication] openURL:phoneUrl];
        
        // Save the phone number for history
//        KatieAddressData *addressData = [KatieDataManager newAddressData];
//        [addressData setCalledAt:[NSDate date]];
//        [addressData setMobileNumberCalled:[NSNumber numberWithInteger:[phoneNumber integerValue]]];
//        [KatieDataManager save];
    }
    else
    {
        //        [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        //        [calert show];
    }
}

- (void)reloadTableView
{
    // Reload table data
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    [self.tableView reloadData];
    //[self loadContacts];
    
    // End the refreshing
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}


#pragma mark - CoreData Settings

- (NSFetchedResultsController *)fetchedResultsController
{
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"KatieAddressData" inManagedObjectContext:[KatieDataManager sharedManager].managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *historyOrder = [[NSSortDescriptor alloc]
                                   initWithKey:@"createdAt" ascending:NO];
    [fetchRequest setSortDescriptors:@[historyOrder]];
    [fetchRequest setFetchBatchSize:20];
    
    [NSFetchedResultsController deleteCacheWithName:@"KatieAddressData"];
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[KatieDataManager sharedManager].managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"KatieAddressData"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    // TODO: Understand what it does
    if (!newIndexPath) {
        return;
    }
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newIndexPath.row inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newIndexPath.row inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // TODO: Need to understand
    [self.tableView endUpdates];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
