//
//  ELManagerIndividualViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELManagerIndividualViewController.h"
#import "ELDevelopmentPlan.h"
#import "ELDevelopmentPlanDetailsViewController.h"
#import "ELManagerIndividualTableViewCell.h"
#import "ELTabPageViewController.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"ManagerIndividualCell";

#pragma mark - Class Extension

@interface ELManagerIndividualViewController ()

@end

@implementation ELManagerIndividualViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = ThemeColor(kELSurveySeparatorColor);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELManagerIndividualTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                             forIndexPath:indexPath];
    
    [cell setDelegate:self];
    [cell configure:@{@"name": @"Test User",
                      @"data": @[@{@"name": @"Public Speaking", @"percentage": @0.5},
                                 @{@"name": @"Leadership", @"percentage": @0.8},
                                 @{@"name": @"Excellence", @"percentage": @0.3}]}
        atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Protocol Methods (ELManagerItemsDelegate)

- (void)onSeeMore:(id)object {
    UINavigationController *navController = StoryboardController(@"TabPage", nil);
    ELTabPageViewController *controller = navController.viewControllers[0];
    
    controller.type = kELListTypeDevPlan;
    controller.tabs = @[@(kELListFilterAll),
                        @(kELListFilterInProgress),
                        @(kELListFilterCompleted),
                        @(kELListFilterExpired)];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onChartSelection:(id)object {
    ELDevelopmentPlan *devPlan = (ELDevelopmentPlan *)object;
    ELDevelopmentPlanDetailsViewController *controller = StoryboardController(@"DevelopmentPlan",
                                                                              @"DevelopmentPlanDetails");
    
    controller.objectId = devPlan.objectId;
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Protocol Methods (XLPagerTabStrip)

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController {
    return [NSLocalizedString(@"kELTabTitleIndividual", nil) uppercaseString];
}

@end
