//
//  ELGoalDetailsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELGoalDetailsViewController.h"
#import "ELAddObjectTableViewCell.h"
#import "ELCategory.h"
#import "ELDevelopmentPlanViewManager.h"
#import "ELDropdownView.h"
#import "ELGoal.h"
#import "ELGoalAction.h"
#import "ELItemTableViewCell.h"

#pragma mark - Private Constants

static CGFloat const kELCategoryViewInitialHeight = 60;
static CGFloat const kELCellHeight = 50;
static CGFloat const kELDatePickerViewInitialHeight = 200;

static NSString * const kELActionCellIdentifier = @"ActionCell";
static NSString * const kELAddActionCellIdentifier = @"AddActionCell";

#pragma mark - Class Extension

@interface ELGoalDetailsViewController ()

@property (nonatomic) BOOL hasCreatedGoal;
@property (nonatomic, strong) NSString *selectedCategory;
@property (nonatomic, strong) NSMutableArray *mActions;
@property (nonatomic, strong) ELDevelopmentPlanViewManager *viewManager;
@property (nonatomic, strong) ELDropdownView *dropdown;

@end

@implementation ELGoalDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.hasCreatedGoal = NO;
    self.mActions = [[NSMutableArray alloc] init];
    self.viewManager = [[ELDevelopmentPlanViewManager alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Goal details
    [self populatePage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (!self.hasCreatedGoal) {
        return;
    }
    
    if (self.toAddNew) {
        [self.delegate onGoalAddition:self.goal];
    } else {
        [self.delegate onGoalUpdate:self.goal];
    }    
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mActions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id value = self.mActions[indexPath.row];
    
    if ([value isKindOfClass:[NSString class]]) {
        ELAddObjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELAddActionCellIdentifier];
        
        [cell.textField setDelegate:self];
        [cell.textField becomeFirstResponder];
        
        return cell;
    } else {
        ELItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELActionCellIdentifier];
        
        cell.tag = indexPath.row;
        cell.delegate = self;
        cell.optionLabel.text = [(ELGoalAction *)value title];
        
        return cell;
    }
}

#pragma mark - Protocol Methods (UITextField)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if ([textField isEqual:self.nameTextField]) {
        return YES;
    }
    
    // Add Option
    [self addNewActionFromTextField:textField];
    
    return YES;
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    NSString *buttonLabel = NSLocalizedString(self.toAddNew ? @"kELDevelopmentPlanGoalButtonAdd" :
                                                              @"kELDevelopmentPlanGoalButtonUpdate", nil);
    
    // Button
    [self.addGoalButton setTitle:[buttonLabel uppercaseString]
                        forState:UIControlStateNormal];
    
    // Date Picker
    [self.datePicker setBackgroundColor:[UIColor clearColor]];    
    [self.datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
}

#pragma mark - Protocol Methods (ELDropdown)

- (void)onDropdownSelectionValueChange:(NSString *)value {
    self.selectedCategory = value;
}

#pragma mark - Protocol Methods (ELItemTableViewCell)

- (void)onDeletionAtRow:(NSInteger)row {
    [self.mActions removeObjectAtIndex:row];
    [self.tableView reloadData];
    [self adjustTableViewSize];
}

#pragma mark - Protocol Methods (DZNEmptyDataSet)

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"No actions added"
                                           attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:14.0f],
                                                        NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

#pragma mark - Private Methods

- (void)addNewActionFromTextField:(UITextField *)textField {
    if (textField.text.length > 0) {
        ELGoalAction *action;
        
        [self.mActions removeObject:@""];
        
        action = [[ELGoalAction alloc] initWithDictionary:@{@"id": @(-1),
                                                            @"title": textField.text,
                                                            @"checked": @NO,
                                                            @"position": @(self.mActions.count)}
                                                    error:nil];
        
        [self.mActions addObject:action];
        [self.tableView reloadData];
        [self adjustTableViewSize];
    }
    
    textField.text = @"";
}

- (void)adjustTableViewSize {
    CGFloat tableViewContentSizeHeight = (kELCellHeight * (self.mActions.count == 0 ? 1: self.mActions.count)) + kELCellHeight;
    
    [self.tableViewHeightConstraint setConstant:tableViewContentSizeHeight];
    [self.tableView updateConstraints];
}

- (void)populatePage {
    NSString *defaultSelection = NSLocalizedString(@"kELGoalCategoryValidationMessage", nil);
    NSMutableArray *mCategories = [[NSMutableArray alloc] init];
    
    for (ELCategory *category in [ELAppSingleton sharedInstance].categories) [mCategories addObject:category.title];
    
    self.dropdown = [[ELDropdownView alloc] initWithItems:mCategories
                                           baseController:self
                                         defaultSelection:defaultSelection];
    self.dropdown.delegate = self;
    self.selectedCategory = defaultSelection;
    self.nameTextField.text = self.goal ? self.goal.title : @"";
    
    // Date
    [self.remindSwitch setOn:self.goal.dueDateChecked];
    [self.datePicker setDate:self.goal ? self.goal.dueDate : [NSDate date]];
    [self toggleBasedOnSwitchValue:self.remindSwitch];
    
    // Category
    [self.categorySwitch setOn:self.goal.categoryChecked];
    [self.dropdown setFrame:self.dropdownView.bounds];
    [self.dropdown setDefaultValue:self.goal ? self.goal.category : defaultSelection];
    [self.dropdownView addSubview:self.dropdown];
    [self toggleBasedOnSwitchValue:self.categorySwitch];
    
    // Actions
    if (self.goal.actions.count == 0) {
        return;
    }
    
    [self.mActions removeAllObjects];
    [self.mActions addObjectsFromArray:self.goal.actions];
    [self.tableView reloadData];
    [self adjustTableViewSize];
}

- (void)toggleBasedOnSwitchValue:(UISwitch *)switchButton {
    if ([switchButton isEqual:self.remindSwitch]) {
        self.dateErrorLabel.hidden = YES;
        self.datePickerViewHeightConstraint.constant = switchButton.isOn ? kELDatePickerViewInitialHeight : 0;
        
        [self.datePickerView updateConstraints];
    } else if ([switchButton isEqual:self.categorySwitch]) {
        self.dropdownHeightConstraint.constant = switchButton.isOn ? kELCategoryViewInitialHeight : 0;
        
        [self.dropdownView updateConstraints];
    }
}

#pragma mark - Interface Builder Actions

- (IBAction)onSwitchValueChange:(id)sender {
    [self toggleBasedOnSwitchValue:(UISwitch *)sender];
}

- (IBAction)onAddActionButtonClick:(id)sender {
    NSIndexPath *indexPath;
    ELAddObjectTableViewCell *cell;
    
    if (self.mActions.count > 0) {
        indexPath = [NSIndexPath indexPathForRow:self.mActions.count - 1 inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell isKindOfClass:[ELAddObjectTableViewCell class]]) {
            [self addNewActionFromTextField:cell.textField];
        }
    }
    
    [self.mActions addObject:@""];
    [self.tableView reloadData];
    [self adjustTableViewSize];
}

- (IBAction)onAddGoalButtonClick:(id)sender {
    BOOL isValid, hasSelection;
    NSString *dateString;
    NSMutableDictionary *mFormItems;
    NSMutableArray *mActions = [[NSMutableArray alloc] init];
    ELFormItemGroup *nameGroup = [[ELFormItemGroup alloc] initWithInput:self.nameTextField
                                                                   icon:nil
                                                             errorLabel:self.nameErrorLabel];
    
    hasSelection = YES;
    
    if (self.mActions.count == 1) {
        [ELUtils presentToastAtView:self.view
                            message:NSLocalizedString(@"kELGoalActionsValidationMessage", nil)
                         completion:^{}];
    }
    
    dateString = [[ELAppSingleton sharedInstance].apiDateFormatter stringFromDate:self.datePicker.date];
    mFormItems = [[NSMutableDictionary alloc] initWithDictionary:@{@"name": nameGroup}];
    
    if (self.remindSwitch.isOn) {
        [mFormItems setObject:[[ELFormItemGroup alloc] initWithText:dateString
                                                               icon:nil
                                                         errorLabel:self.dateErrorLabel]
                       forKey:@"date"];
    }
    
    if (self.categorySwitch.isOn) {
        hasSelection = self.dropdown.hasSelection;
    }
    
    isValid = [self.viewManager validateAddGoalFormValues:[mFormItems copy]];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (!(isValid && hasSelection)) {
        return;
    }
    
    [self.mActions removeObjectAtIndex:self.mActions.count - 1];
    
    for (ELGoalAction *action in self.mActions) [mActions addObject:[action toDictionary]];
    
    self.hasCreatedGoal = YES;
    self.goal = [[ELGoal alloc] initWithDictionary:@{@"title": self.nameTextField.text,
                                                     @"description": self.descriptionTextView.text,
                                                     @"checked": @NO,
                                                     @"position": @0,
                                                     @"dueDate": dateString,
                                                     @"reminderSent": @NO,
                                                     @"actions": [mActions copy]}
                                             error:nil];
    self.goal.category = self.selectedCategory;
    self.goal.categoryChecked = self.categorySwitch.on;
    self.goal.dueDateChecked = self.remindSwitch.on;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
