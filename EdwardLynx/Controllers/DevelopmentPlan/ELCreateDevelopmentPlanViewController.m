//
//  ELCreateDevelopmentPlanViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELCreateDevelopmentPlanViewController.h"
#import "ELDevelopmentPlanViewManager.h"
#import "ELGoal.h"
#import "ELGoalDetailsViewController.h"

#pragma mark - Private Constants

static CGFloat const kELCellHeight = 60;
static CGFloat const kELFormViewHeight = 100;
static CGFloat const kELIconSize = 15;
static CGFloat const kELSectionHeight = 17;

static NSString * const kELAddGoalCellIdentifier = @"AddGoalCell";
static NSString * const kELGoalCellIdentifier = @"GoalCell";

static NSString * const kELAddGoalSegueIdentifier = @"AddGoal";
static NSString * const kELGoalSegueIdentifier = @"GoalDetail";

#pragma mark - Class Extension

@interface ELCreateDevelopmentPlanViewController ()

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray<ELGoal *> *mGoals;
@property (nonatomic, strong) ELGoal *selectedGoal;
@property (nonatomic, strong) ELDevelopmentPlanViewManager *viewManager;

@end

@implementation ELCreateDevelopmentPlanViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.mGoals = [[NSMutableArray alloc] init];
    self.nameTextField.delegate = self;
    
    self.viewManager = [[ELDevelopmentPlanViewManager alloc] init];
    self.viewManager.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = kELCellHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // Populate page
    if (self.devPlan) {
        [self populatePage];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BOOL toAddNew = [segue.identifier isEqualToString:kELAddGoalSegueIdentifier];
    ELGoalDetailsViewController *controller = (ELGoalDetailsViewController *)[segue destinationViewController];
        
    controller.delegate = self;
    controller.toAddNew = toAddNew;
    controller.goal = self.selectedGoal;
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mGoals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSRange indexRange, goalTitleRange;
    UIImage *image;
    UITableViewCell *cell;
    ELGoal *goal = self.mGoals[indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@. %@", @(indexPath.row + 1), goal.title];
    NSDictionary *attributesDict = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:16.0f]};
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:title
                                                                                       attributes:attributesDict];
    
    // Content
    indexRange = [title rangeOfString:[NSString stringWithFormat:@"%@.", @(indexPath.row + 1)]];
    goalTitleRange = [title rangeOfString:goal.title];
    
    [attributedText addAttribute:NSForegroundColorAttributeName
                           value:[[RNThemeManager sharedManager] colorForKey:kELVioletColor]
                           range:indexRange];
    [attributedText addAttribute:NSForegroundColorAttributeName
                           value:[UIColor whiteColor]
                           range:goalTitleRange];
    
    cell = [tableView dequeueReusableCellWithIdentifier:kELGoalCellIdentifier];
    cell.textLabel.attributedText = attributedText;
    
    // UI
    image = [FontAwesome imageWithIcon:fa_chevron_right
                             iconColor:[[RNThemeManager sharedManager] colorForKey:kELOrangeColor]
                              iconSize:kELIconSize
                             imageSize:CGSizeMake(kELIconSize, kELIconSize)];
    cell.accessoryView = [[UIImageView alloc] initWithImage:image];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ELGoal *goal = self.mGoals[indexPath.row];
    
    self.selectedIndexPath = indexPath;
    
    [self setSelectedGoal:goal];
    [self performSegueWithIdentifier:kELGoalSegueIdentifier sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    ELGoal *goal = self.mGoals[indexPath.row];
    
    return !goal.isAlreadyAdded;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Remove the deleted object from your data source.
        // If your data source is an NSMutableArray, do this
        [self.mGoals removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

#pragma mark - Protocol Methods (UITextField)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    return YES;
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    CGFloat iconHeight = 15;
    
    // Button
    [self.addGoalButton setImage:[FontAwesome imageWithIcon:fa_plus
                                                  iconColor:[UIColor blackColor]
                                                   iconSize:iconHeight
                                                  imageSize:CGSizeMake(iconHeight, iconHeight)]
                        forState:UIControlStateNormal];
}

#pragma mark - Protocol Methods (ELDevelopmentPlanViewManager)

- (void)onAPIPostResponseError:(NSDictionary *)errorDict {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDevelopmentPlanCreateError", nil)
                     completion:nil];
}

- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict {
    __weak typeof(self) weakSelf = self;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDevelopmentPlanCreateSuccess", nil)
                     completion:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Protocol Methods (ELDevelopmentPlanGoal)

- (void)onGoalAddition:(__kindof ELModel *)object {
    [self.mGoals addObject:(ELGoal *)object];
    [self.tableView reloadData];
    [self adjustScrollViewContentSize];
    
    [ELUtils scrollViewToBottom:self.scrollView];
}

- (void)onGoalUpdate:(__kindof ELModel *)object {
    ELGoal *goal = (ELGoal *)object;
    
    [self.mGoals replaceObjectAtIndex:self.selectedIndexPath.row withObject:goal];
    [self.tableView reloadData];
}

#pragma mark - Protocol Methods (DZNEmptyDataSet)

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"kELGoalsValidationMessage", nil)
                                           attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:14.0f],
                                                        NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

#pragma mark - Private Methods

- (void)adjustScrollViewContentSize {
    CGFloat tableViewContentSizeHeight = self.mGoals.count == 0 ? kELCellHeight : self.mGoals.count * kELCellHeight;
    
    if (tableViewContentSizeHeight == 0) {
        return;
    }
    
    [self.heightConstraint setConstant:tableViewContentSizeHeight + kELSectionHeight];
    [self.tableView updateConstraints];
    
    // Set the content size of your scroll view to be the content size of your
    // table view + whatever else you have in the scroll view.
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width,
                                               (kELFormViewHeight + tableViewContentSizeHeight))];
}

- (void)populatePage {
    self.nameTextField.text = self.devPlan.name;
    
    [self.mGoals addObjectsFromArray:self.devPlan.goals];
    [self.tableView reloadData];
    [self adjustScrollViewContentSize];
}

#pragma mark - Interface Builder Actions

- (IBAction)onDoneButtonClick:(id)sender {
    BOOL isValid;
    NSMutableArray *mGoals = [[NSMutableArray alloc] init];
    ELFormItemGroup *nameGroup = [[ELFormItemGroup alloc] initWithInput:self.nameTextField
                                                                   icon:nil
                                                             errorLabel:self.nameErrorLabel];
    
    if (self.mGoals.count == 0) {
        [ELUtils presentToastAtView:self.view
                            message:NSLocalizedString(@"kELGoalsValidationMessage", nil)
                         completion:nil];
    }
    
    isValid = [self.viewManager validateDevelopmentPlanFormValues:@{@"name": nameGroup}];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (!isValid) {
        return;
    }
    
    // Loading alert
    [self presentViewController:[ELUtils loadingAlert]
                       animated:YES
                     completion:nil];
    
    for (ELGoal *goal in self.mGoals) [mGoals addObject:[goal toDictionary]];
    
    [self.viewManager processCreateDevelopmentPlan:@{@"name": self.nameTextField.text,
                                                     @"target": @(AppSingleton.user.objectId),
                                                     @"goals": [mGoals copy]}];
}

- (IBAction)onAddGoalButtonClick:(id)sender {
    [self.nameTextField resignFirstResponder];
    [self setSelectedGoal:nil];
    [self performSegueWithIdentifier:kELAddGoalSegueIdentifier sender:self];
}

@end
