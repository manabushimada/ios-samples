//
//  FeatureViewController.h
//  Katie
//
//  Created by manabu shimada on 31/01/2016.
//  Copyright © 2016 manabu shimada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController
<UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;

@end
