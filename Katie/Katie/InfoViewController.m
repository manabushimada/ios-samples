//
//  FeatureViewController.m
//  Katie
//
//  Created by manabu shimada on 31/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import "InfoViewController.h"

#import "KatieNetworkManager.h"
#import "CarrierInfoTableViewCell.h"
#import "KatieFonts.h"
#import "KatieColor.h"

@interface InfoViewController ()

@property (nonatomic, strong) NSMutableArray *carriersArray;

@end

@implementation InfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self.infoTableView setBackgroundColor:[UIColor clearColor]];
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    for (UIViewController *controller = self; controller != nil; controller = controller.parentViewController) {
        controller.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.carriersArray = [NSMutableArray new];
    NSArray *carrierArray = [KatieNetworkManager carrierArrayInPlist];
    for (NSDictionary *dict in carrierArray){
        [self.carriersArray addObject:dict];
    }
    
    /*----------------------------------------------------------------------------*
     * Setup my tableView settings
     *----------------------------------------------------------------------------*/
    [self.infoTableView registerNib:[UINib nibWithNibName:@"CarrierInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CarrierInfoCell"];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    // TODO:
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carriersArray.count;
}

- (CarrierInfoTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CarrierInfoCell";
    CarrierInfoTableViewCell *cell = [self.infoTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[CarrierInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    [cell updateWithDictionary:self.carriersArray[indexPath.row]];
    
    return cell;
}


#pragma mark - Setups
- (void)setupNavigationItem
{
    // Set NavigationItem label configuration
    self.navigationController.navigationBar.topItem.title = @"Carrier Types";
    self.navigationController.navigationBar.titleTextAttributes =
    @{NSForegroundColorAttributeName : [KatieColor yvesKleinBlue], NSFontAttributeName : [KatieFonts katieFontNavigationItem]};
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
