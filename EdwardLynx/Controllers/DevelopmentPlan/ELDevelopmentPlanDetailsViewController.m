//
//  ELDevelopmentPlanDetailsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 01/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDevelopmentPlanDetailsViewController.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"GoalCell";

#pragma mark - Class Extension

@interface ELDevelopmentPlanDetailsViewController ()

@end

@implementation ELDevelopmentPlanDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.title = [self.devPlan.name uppercaseString];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devPlan.goals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELGoalTableViewCell *cell = (ELGoalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kELCellIdentifier];
    
    [cell configure:self.devPlan.goals[indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

@end
