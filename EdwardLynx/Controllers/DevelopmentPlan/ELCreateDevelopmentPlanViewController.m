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
static CGFloat const kELFormViewHeight = 125;

static NSString * const kELAddGoalCellIdentifier = @"AddGoalCell";
static NSString * const kELGoalCellIdentifier = @"GoalCell";

static NSString * const kELAddGoalSegueIdentifier = @"AddGoal";
static NSString * const kELGoalSegueIdentifier = @"GoalDetail";

#pragma mark - Class Extension

@interface ELCreateDevelopmentPlanViewController ()

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *mGoals;
@property (nonatomic, strong) ELGoal *selectedGoal;
@property (nonatomic, strong) ELDevelopmentPlanViewManager *viewManager;
@property (nonatomic, strong) ELFormItemGroup *nameGroup;

@end

@implementation ELCreateDevelopmentPlanViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.mGoals = [[NSMutableArray alloc] initWithArray:@[@""]];
    self.nameGroup = [[ELFormItemGroup alloc] initWithInput:self.nameTextField
                                                       icon:nil
                                                 errorLabel:self.nameErrorLabel];
    
    self.viewManager = [[ELDevelopmentPlanViewManager alloc] init];
    self.viewManager.delegate = self;
    
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
    ELGoalDetailsViewController *controller = (ELGoalDetailsViewController *)[segue destinationViewController];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id value = self.mGoals[indexPath.row];
    
    self.selectedIndexPath = indexPath;
    
    [self setSelectedGoal:[value isKindOfClass:[NSString class]] ? nil : (ELGoal *)value];
    [self performSegueWithIdentifier:[value isKindOfClass:[NSString class]] ? kELAddGoalSegueIdentifier : kELGoalSegueIdentifier
                              sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id value = self.mGoals[indexPath.row];
    
    return [value isKindOfClass:[NSString class]] ? kELCellHeight : UITableViewAutomaticDimension;
}

#pragma mark - Protocol Methods (ELDevelopmentPlanViewManager)

- (void)onAPIPostResponseError:(NSDictionary *)errorDict {
    DLog(@"%@: %@", [self class], errorDict);
}

- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict {
    self.doneButton.enabled = YES;
    
    // Back to the Dashboard
    [ELUtils presentToastAtView:self.view
                        message:@"Development Plan successfully created."
                     completion:^{
                         [self presentViewController:[[UIStoryboard storyboardWithName:@"LeftMenu" bundle:nil]
                                                      instantiateInitialViewController]
                                            animated:YES
                                          completion:nil];
                     }];
}

#pragma mark - Protocol Methods (ELDevelopmentPlanGoal)

- (void)onGoalAddition:(__kindof ELModel *)object {
    ELGoal *goal = (ELGoal *)object;
    NSInteger position = self.mGoals.count - 1;
    
    goal.position = position;
    
    [self.mGoals insertObject:goal atIndex:position];
    [self.tableView reloadData];
    [self adjustScrollViewContentSize];
    [ELUtils scrollViewToBottom:self.scrollView];
}

- (void)onGoalUpdate:(__kindof ELModel *)object {
    ELGoal *goal = (ELGoal *)object;
    
    [self.mGoals replaceObjectAtIndex:self.selectedIndexPath.row withObject:goal];
    [self.tableView reloadData];
}

#pragma mark - Private Methods

- (void)adjustScrollViewContentSize {
    CGRect tableFrame = self.tableView.frame;
    CGFloat tableViewContentSizeHeight = self.tableView.contentSize.height;
    
    if (tableViewContentSizeHeight == 0) {
        return;
    }
    
    tableFrame.size.height = tableViewContentSizeHeight;
    
    [self.tableView setFrame:tableFrame];
    [self.tableView setContentSize:CGSizeMake(self.tableView.contentSize.width,
                                              tableViewContentSizeHeight)];
    
    // Set the content size of your scroll view to be the content size of your
    // table view + whatever else you have in the scroll view.
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width,
                                               (kELFormViewHeight + tableViewContentSizeHeight))];
}

#pragma mark - Interface Builder Actions

- (IBAction)onDoneButtonClick:(id)sender {
    BOOL isValid;
    NSMutableArray *mGoals = [[NSMutableArray alloc] init];
    
    if (self.mGoals.count == 1) {
        [ELUtils presentToastAtView:self.view
                            message:@"No goals added"
                         completion:^{}];
        
        return;
    }
    
    isValid = [self.viewManager validateDevelopmentPlanFormValues:@{@"name": self.nameGroup}];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (!isValid) {
        return;
    }
    
    [self.doneButton setEnabled:NO];
    [self.mGoals removeObjectAtIndex:self.mGoals.count - 1];
    
    for (ELGoal *goal in self.mGoals) [mGoals addObject:[goal toDictionary]];
    
    [self.viewManager processCreateDevelopmentPlan:@{@"name": self.nameTextField.text,
                                                     @"target": @([ELAppSingleton sharedInstance].user.objectId),
                                                     @"goals": [mGoals copy]}];
}

@end
