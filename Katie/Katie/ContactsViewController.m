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
    
    /*----------------------------------------------------------------------------*
     * Setup my tableView settings
     *----------------------------------------------------------------------------*/
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ContactCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
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
        // TODO:
       // KatieAddressData *addressData = self.fetchedResultsController.fetchedObjects[indexPath.row];
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
            dispatch_group_t serviceGroup = dispatch_group_create();
            for (APContact *contact in contacts)
            {
                // Store APContact objects
                [weakSelf.apContact addObject:contact];
                
                [weakSelf.namesData addObject:contact.name.compositeName?contact.name.compositeName:@"untitled contact"];
                [weakSelf.phoneNumbersData addObject:contact.phones[0].number];
            }
            
            [KatieDataManager registerMyContacts:weakSelf.apContact];
            
            // TODO: Reload after finishing querying completely.
            [weakSelf.tableView reloadData];
            
            dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),^{
                // Query Lookup API after everything has finished
               [weakSelf updateMyContacts];
            });
           
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


- (void)queryLookupAPIWithAddressData:(KatieAddressData *)addressData
{
    // TODO: It doesn't correspond a multiple of phone numbers for this app.
    NSString *newPhoneNumber = [NSString stringByRemovingAlphabets:addressData.phoneNumber];
    newPhoneNumber = [NSString stringByAddingCountryCode:newPhoneNumber];
    NSString *contactName = addressData.contactName;
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    if (![newPhoneNumber isEqualToString:kKatieUnknowPhoneNumber] && [NSString isStringContainingCountryCode:newPhoneNumber])
    {
        // Ensure a phone number must constain country code itself.
        NSLog(@"will query Lookup API %@ with %@", [NSString stringByRemovingSpaces:newPhoneNumber], contactName);
        [[KatieNetworkManager sharedManager] getContactDataWithPhoneNumber:[NSString stringByRemovingSpaces:newPhoneNumber] contactName:contactName];
    }
    else
    {
        /*----------------------------------------------------------------------------*
         * An recogniaable or no counrty code phone number code should be saved into CoreData.
         * Because it won't get Lookup response.
         *----------------------------------------------------------------------------*/
        dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),^{
            // Query Lookup API after everything has finished
            [self registerErrorContactWithAddressData:addressData];
        });
    }
}

- (void)registerErrorContactWithAddressData:(KatieAddressData *)addressData
{
    NSLog(@"error address contact %@", addressData.phoneNumber);
    if (!addressData.dummyCarrier) {
        [addressData setDummyCarrier:@"Unknown"];
        [addressData setCarrierColor:@"a5a5a5"];
        [KatieDataManager save];
    }
}

- (void)updateMyContacts
{
     //Register the address book from an user's device
    for (int i = 0; i < self.fetchedResultsController.fetchedObjects.count; i++)
    {
        KatieAddressData *addressData = self.fetchedResultsController.fetchedObjects[i];
        if (addressData.dummyCarrier)
        {
            /*----------------------------------------------------------------------------*
             * The phone number has been already populated into CoreData.
             * No need to query Lookup API.
             *----------------------------------------------------------------------------*/
            NSLog(@"has been populated with %@ name %@", addressData.phoneNumber, addressData.contactName);
            continue;
        }
        else
        {
            /*----------------------------------------------------------------------------*
             * The phone number has not been saved into CoreData.
             * Need to query Lookup API.
             *----------------------------------------------------------------------------*/
            [self queryLookupAPIWithAddressData:addressData];
        }
    }
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
    
    //[self loadContacts];
    [self.tableView reloadData];
    
    NSArray *datas = [KatieDataManager allAddressData];
    for (KatieAddressData *addressData in datas)
    {
        NSLog(@"Data in coredata %@", [addressData dictionaryRepresentation]);
    }
    
    // End the refreshing
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}


#pragma mark - NSFetchedResultsController Delegate

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
    
    if (!newIndexPath) {
        return;
    }
    
    // TODO: Start working after taking care of core data
    
//    switch (type)
//    {
//        case NSFetchedResultsChangeInsert: // Called when inserting a new data into CoreData
//            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newIndexPath.row inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//        case NSFetchedResultsChangeDelete: // Called when deleting it
//            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newIndexPath.row inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        default:
//            break;
//    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // Called as soon as data is changed.
    [self.tableView endUpdates];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
