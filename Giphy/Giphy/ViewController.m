//
//  ViewController.m
//  BlackSwanFeverApp
//
//  Created by manabu shimada on 13/01/2016.
//  Copyright © 2016 Asio Ltd. All rights reserved.
//

#import "ViewController.h"

#define kGiphyCollectionCellDefaultColor  [UIColor clearColor]
#define kGiphyCollectionCellSelectedColor  [UIColor magentaColor]

NSString *const kCollectionViewCellIdentifier = @"cellReuseIdentifier";
NSInteger const kGiphySearchNumbers = 50;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [AXCGiphy setGiphyAPIKey:kGiphyPublicAPIKey];
    self.numberOfCells = kGiphySearchNumbers;

    // Set a default keyword for quering Giphy API
    self.searchedText = @"David Bowie";
    self.searchBar.text = self.searchedText;
    [self queryAXCGiphy:self.searchedText];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self createCategoriesButtons];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)
                                                 name:AFNetworkingReachabilityDidChangeNotification object: nil];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.giphyResults.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*----------------------------------------------------------------------------*
     * Giphy collection view.
     *----------------------------------------------------------------------------*/
    GiphyCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    
    cell.giphyImageView.image = nil;
    
    // Set a colour of a selected cell
    cell.selectedBackgroundView = nil;
    if (cell.selected)
    {
        cell.backgroundColor = kGiphyCollectionCellSelectedColor;
    }
    else
    {
        cell.backgroundColor = kGiphyCollectionCellDefaultColor;
    }
    
    AXCGiphy *gif = self.giphyResults[indexPath.item];
    
    [cell startActiveIndicator];
    
    // Download a gif
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:gif.fixedHeightDownsampledImage.url
                          options:SDWebImageRetryFailed
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image)
                            {
                                cell.giphyImageView.image = image;
                                [cell stopActiveIndicator];
                            }
                        }];
    
    // Load cells more
    if(indexPath.row == self.numberOfCells - 1)
        [self loadCells];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    GiphyCollectionViewCell *cell = (GiphyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = kGiphyCollectionCellSelectedColor;

    AXCGiphy *gif = self.giphyResults[indexPath.item];
    self.sentURL = [gif.originalImage.mp4 absoluteString];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GiphyCollectionViewCell *cell = (GiphyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = kGiphyCollectionCellDefaultColor; // Default color
}

#pragma mark - AXCGiphy

- (void)queryAXCGiphy:(NSString *)searchText
{
    [AXCGiphy searchGiphyWithTerm:searchText
                            limit:self.numberOfCells
                           offset:0
                       completion:^(NSArray *results, NSError *error)
     {
         self.giphyResults = results;
         
         if (self.giphyResults)
         {
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 [self.collectionView reloadData];
                 [self cellUpToTop];
             }];
         }
     }];
}

- (void)cellUpToTop
{
    // Move cells to the top
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    [self.view layoutIfNeeded];
}

- (void)loadCells
{
    self.numberOfCells += 20;
    [self queryAXCGiphy:self.searchBar.text];
}

#pragma mark - GiphyScrollView Delegate

- (void)buttonInScrollViewTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *categories = button.titleLabel.text;
    
    [self highlightOffCategoriesButtons];
    button.backgroundColor = [UIColor yellowColor];
    
    self.searchBar.text = categories;
    [self queryAXCGiphy:self.searchBar.text];
}

#pragma mark - UISearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchedText = searchText;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self highlightOffCategoriesButtons];
    [self queryAXCGiphy:searchBar.text];

    [searchBar resignFirstResponder];
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*----------------------------------------------------------------------------*
     * Dismiss keyboard when tapping the other area outside.
     *----------------------------------------------------------------------------*/
    [self.searchBar resignFirstResponder];
}

#pragma UIAlertView

- (void)didAlertStates:(NSUInteger)status
{
    switch (status) {
        case AlertStateNoSearchResults:
        {
            [[[UIAlertView alloc] initWithTitle:@"No Search Results" message:@"Type again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
            break;
        case AlertStateNoNetwork:
        {
            [[[UIAlertView alloc] initWithTitle:@"No Network" message:@"You appear to be offline. Please connect to view this page." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
            break;
            
    }
}

#pragma mark - Private Methods

- (void)createCategoriesButtons
{
    /*----------------------------------------------------------------------------*
     * Create GiphyCategories Scroll View.
     *----------------------------------------------------------------------------*/
    self.giphyCategoriesScrollView.delegateClass = self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GiphyServices" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *plistArray = [NSArray arrayWithArray:[dic objectForKey:@"categories"]];
    self.categoriesButtons = [self.giphyCategoriesScrollView createScrollViewWithButtons:plistArray
                                                                                selector:@selector(buttonInChirpScrollViewPressed:)];
}

- (void)highlightOffCategoriesButtons
{
    // Highlight all buttons Off
    for (UIButton *thisButton in self.categoriesButtons)
        thisButton.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Notifications
- (void)reachabilityChanged: (NSNotification *)notification
{
    NSNumber *statusNumber = notification.userInfo[AFNetworkingReachabilityNotificationStatusItem];
    AFNetworkReachabilityStatus status = [statusNumber integerValue];
    
    if (status) {
        // Show an alert message if a device is out of connection.
        [self didAlertStates:AlertStateNoSearchResults];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
