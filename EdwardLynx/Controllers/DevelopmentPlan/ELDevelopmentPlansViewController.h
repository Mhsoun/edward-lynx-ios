//
//  ELDevelopmentPlansViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELDataProvider.h"
#import "ELDevelopmentPlan.h"
#import "ELTableDataSource.h"

@interface ELDevelopmentPlansViewController : ELBaseViewController<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *allTabButton;
@property (weak, nonatomic) IBOutlet UIButton *unfinishedTabButton;
@property (weak, nonatomic) IBOutlet UIButton *completedTabButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)onTabButtonClick:(id)sender;

@end
