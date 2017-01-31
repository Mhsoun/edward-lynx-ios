//
//  ELCreateDevelopmentPlanViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELCreateDevelopmentPlanViewController.h"

#pragma mark - Private Constants

static NSString * const kELAddGoalCellIdentifier = @"AddGoalCell";
static NSString * const kELGoalCellIdentifier = @"GoalCell";

static NSString * const kELAddGoalSegueIdentifier = @"AddGoal";
static NSString * const kELGoalSegueIdentifier = @"GoalDetail";

#pragma mark - Class Extension

@interface ELCreateDevelopmentPlanViewController ()

@property (nonatomic, strong) NSMutableArray *mGoals;
@property (nonatomic, strong) ELGoal *selectedGoal;

@end

@implementation ELCreateDevelopmentPlanViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.mGoals = [[NSMutableArray alloc] initWithArray:@[@""]];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ELDevelopmentPlanDetailViewController *controller = (ELDevelopmentPlanDetailViewController *)[segue destinationViewController];
    BOOL toAddNew = [segue.identifier isEqualToString:kELAddGoalSegueIdentifier];
    
    controller.toAddNew = toAddNew;
    controller.goal = self.selectedGoal;
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mGoals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    id value = self.mGoals[indexPath.row];
    
    if ([value isKindOfClass:[NSString class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:kELAddGoalCellIdentifier];
    } else {
        ELGoal *goal = (ELGoal *)value;
        
        cell = [tableView dequeueReusableCellWithIdentifier:kELGoalCellIdentifier];
        cell.textLabel.text = goal.name;
        cell.detailTextLabel.text = @"Some description";  // TEMP
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id value = self.mGoals[indexPath.row];
    
    [self setSelectedGoal:[value isKindOfClass:[NSString class]] ? nil : (ELGoal *)value];
    [self performSegueWithIdentifier:[value isKindOfClass:[NSString class]] ? kELAddGoalSegueIdentifier : kELGoalSegueIdentifier
                                                   sender:self];
}

#pragma mark - Interface Builder Actions

- (IBAction)onDoneButtonClick:(id)sender {
    //
}

@end
