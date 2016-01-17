//
//  ViewController.h
//  BlackSwanFeverApp
//
//  Created by manabu shimada on 13/01/2016.
//  Copyright © 2016 Asio Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScrollViewWithButtons.h"
#import "GiphyCollectionViewCell.h"
#import <Giphy-iOS/AXCGiphy.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>

enum
{
    AlertStateNoSearchResults,
    AlertStateNoNetwork
};
typedef NSUInteger AlertState;

@interface ViewController : UIViewController
<UISearchBarDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
ScrollViewWithButtonsDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView        *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar             *searchBar;
@property (weak, nonatomic) IBOutlet ScrollViewWithButtons *giphyCategoriesScrollView;

@property (strong, nonatomic) NSArray                        *giphyResults;
@property (strong, nonatomic) NSString                       *sentURL;
@property (copy, nonatomic) NSString                         *searchedText;
@property (strong, nonatomic) NSArray                        *categoriesButtons;
@property (assign, nonatomic) NSInteger                      numberOfCells;

- (void)queryAXCGiphy:(NSString *)searchText;
- (void)cellUpToTop;
- (void)loadCells;
- (void)didAlertStates:(NSUInteger)status;
- (void)createCategoriesButtons;
- (void)highlightOffCategoriesButtons;
- (void)reachabilityChanged: (NSNotification *)notification;

@end

