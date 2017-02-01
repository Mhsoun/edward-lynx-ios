//
//  ELCreateDevelopmentPlanViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELCreateDevelopmentPlanViewController.h"

#pragma mark - Private Constants

static CGFloat const kELCellHeight = 60;

static NSString * const kELAddGoalCellIdentifier = @"AddGoalCell";
static NSString * const kELGoalCellIdentifier = @"GoalCell";

static NSString * const kELAddGoalSegueIdentifier = @"AddGoal";
static NSString * const kELGoalSegueIdentifier = @"GoalDetail";

#pragma mark - Class Extension

@interface ELCreateDevelopmentPlanViewController ()

@property (nonatomic, strong) NSMutableArray *mGoals;
@property (nonatomic, strong) ELGoal *selectedGoal;
@property (nonatomic, strong) ELDevelopmentPlanViewManager *viewManager;

@end

@implementation ELCreateDevelopmentPlanViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.mGoals = [[NSMutableArray alloc] initWithArray:@[@""]];
    self.viewManager = [[ELDevelopmentPlanViewManager alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.estimatedRowHeight = kELCellHeight;
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
    
    controller.delegate = self;
    controller.toAddNew = toAddNew;
    controller.goal = self.selectedGoal;
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mGoals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id value = self.mGoals[indexPath.row];
    
    if ([value isKindOfClass:[NSString class]]) {
        return [tableView dequeueReusableCellWithIdentifier:kELAddGoalCellIdentifier];
    } else {
        ELGoalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELGoalCellIdentifier];
        
        [cell configure:value atIndexPath:indexPath];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id value = self.mGoals[indexPath.row];
    
    return [value isKindOfClass:[NSString class]] ? kELCellHeight : UITableViewAutomaticDimension;
}

#pragma mark - Protocol Methods (ELDevelopmentPlanGoal)

- (void)onGoalAddition:(__kindof ELModel *)object {
    ELGoal *goal = (ELGoal *)object;
    
    [self.mGoals insertObject:goal atIndex:self.mGoals.count - 1];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id value = self.mGoals[indexPath.row];
    
    [self setSelectedGoal:[value isKindOfClass:[NSString class]] ? nil : (ELGoal *)value];
    [self performSegueWithIdentifier:[value isKindOfClass:[NSString class]] ? kELAddGoalSegueIdentifier : kELGoalSegueIdentifier
                                                   sender:self];
}

#pragma mark - Interface Builder Actions

- (IBAction)onDoneButtonClick:(id)sender {
    BOOL isValid = [self.viewManager validateDevelopmentPlanFormValues:@{}];
    
    if (!isValid) {
        return;
    }
    
    self.doneButton.enabled = NO;
    
    // TODO API Call
}

@end
