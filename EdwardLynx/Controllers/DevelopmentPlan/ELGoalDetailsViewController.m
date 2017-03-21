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
#import "ELGoal.h"
#import "ELGoalAction.h"
#import "ELItemTableViewCell.h"

#pragma mark - Private Constants

static CGFloat const kELCategoryViewInitialHeight = 35;
static CGFloat const kELCellHeight = 50;
static CGFloat const kELDatePickerViewInitialHeight = 200;

static NSString * const kELActionCellIdentifier = @"ActionCell";
static NSString * const kELAddActionCellIdentifier = @"AddActionCell";

#pragma mark - Class Extension

@interface ELGoalDetailsViewController ()

@property (nonatomic) BOOL hasCreatedGoal;
@property (nonatomic, strong) NSMutableArray *mActions;
@property (nonatomic, strong) ELDevelopmentPlanViewManager *viewManager;

@end

@implementation ELGoalDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.hasCreatedGoal = NO;
    self.categoryLabel.text = NSLocalizedString(@"kELGoalCategoryValidationMessage", nil);
    self.mActions = [[NSMutableArray alloc] initWithArray:@[@""]];
    self.viewManager = [[ELDevelopmentPlanViewManager alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
        
        cell.textField.delegate = self;
        
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
    if (textField.text.length > 0) {
        NSInteger position = self.mActions.count - 1;
        ELGoalAction *action = [[ELGoalAction alloc] initWithDictionary:@{@"id": @(-1),
                                                                          @"title": textField.text,
                                                                          @"checked": @NO,
                                                                          @"position": @(position)}
                                                                  error:nil];
        
        [self.mActions insertObject:action atIndex:position];
        [self.tableView reloadData];
        [self adjustTableViewSize];
    }
    
    textField.text = @"";
    
    return YES;
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    CGFloat iconSize = 15;
    NSString *buttonLabel = NSLocalizedString(self.toAddNew ? @"kELDevelopmentPlanGoalButtonAdd" :
                                                              @"kELDevelopmentPlanGoalButtonUpdate", nil);
    
    // Button
    [self.addGoalButton setTitle:[buttonLabel uppercaseString]
                        forState:UIControlStateNormal];
    [self.categoryButton setImage:[FontAwesome imageWithIcon:fa_chevron_down
                                                   iconColor:nil
                                                    iconSize:iconSize
                                                   imageSize:CGSizeMake(iconSize, iconSize)]
                         forState:UIControlStateNormal];
    [self.categoryButton setTintColor:[[RNThemeManager sharedManager] colorForKey:kELTextFieldInputColor]];
    
    // Date Picker
    [self.datePicker setBackgroundColor:[UIColor clearColor]];    
    [self.datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
}

#pragma mark - Protocol Methods (ELItemTableViewCell)

- (void)onDeletionAtRow:(NSInteger)row {
    [self.mActions removeObjectAtIndex:row];
    [self.tableView reloadData];
    [self adjustTableViewSize];
}

#pragma mark - Private Methods

- (void)adjustTableViewSize {
    CGFloat tableViewContentSizeHeight = (kELCellHeight * self.mActions.count) + kELCellHeight;
    
    [self.tableViewHeightConstraint setConstant:tableViewContentSizeHeight];
    [self.tableView updateConstraints];
}

- (void)populatePage {
    self.nameTextField.text = self.goal ? self.goal.title : @"";
    
    // Date
    [self.remindSwitch setOn:self.goal.dueDateChecked];
    [self.datePicker setDate:self.goal ? self.goal.dueDate : [NSDate date]];
    [self toggleBasedOnSwitchValue:self.remindSwitch];
    
    // Category
    [self.categorySwitch setOn:self.goal.categoryChecked];
    [self.categoryLabel setText:self.goal.category.length == 0 ? NSLocalizedString(@"kELGoalCategoryValidationMessage", nil) :
                                                                 self.goal.category];
    [self toggleBasedOnSwitchValue:self.categorySwitch];
    
    // Actions
    if (self.goal.actions.count == 0) {
        return;
    }
    
    [self.mActions removeAllObjects];
    [self.mActions addObjectsFromArray:self.goal.actions];
    [self.mActions addObject:@""];
    [self.tableView reloadData];
    [self adjustTableViewSize];
}

- (void)toggleBasedOnSwitchValue:(UISwitch *)switchButton {
    if ([switchButton isEqual:self.remindSwitch]) {
        self.dateErrorLabel.hidden = YES;
        self.datePickerViewHeightConstraint.constant = switchButton.isOn ? kELDatePickerViewInitialHeight : 0;
        
        [self.datePickerView updateConstraints];
    } else if ([switchButton isEqual:self.categorySwitch]) {
        self.categoryViewHeightConstraint.constant = switchButton.isOn ? kELCategoryViewInitialHeight : 0;
        
        [self.categoryView updateConstraints];
    }
}

#pragma mark - Interface Builder Actions

- (IBAction)onSwitchValueChange:(id)sender {
    [self toggleBasedOnSwitchValue:(UISwitch *)sender];
}

- (IBAction)onCategoryButtonClick:(id)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    void (^actionBlock)(UIAlertAction *) = ^(UIAlertAction *action) {
        self.categoryLabel.text = action.title;
    };
    
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    
    for (ELCategory *category in [ELAppSingleton sharedInstance].categories) {
        [controller addAction:[UIAlertAction actionWithTitle:category.title
                                                       style:UIAlertActionStyleDefault
                                                     handler:actionBlock]];
    }
    
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}

- (IBAction)onAddGoalButtonClick:(id)sender {
    BOOL isValid;
    NSString *dateString;
    NSMutableDictionary *mFormItems;
    NSMutableArray *mActions = [[NSMutableArray alloc] init];
    ELFormItemGroup *nameGroup = [[ELFormItemGroup alloc] initWithInput:self.nameTextField
                                                                   icon:nil
                                                             errorLabel:self.nameErrorLabel];
    
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
        [mFormItems setObject:[[ELFormItemGroup alloc] initWithText:self.categoryLabel.text
                                                               icon:nil
                                                         errorLabel:self.categoryErrorLabel]
                       forKey:@"category"];
    }
    
    isValid = [self.viewManager validateAddGoalFormValues:[mFormItems copy]];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (!isValid) {
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
    self.goal.category = self.categoryLabel.text;
    self.goal.categoryChecked = self.categorySwitch.on;
    self.goal.dueDateChecked = self.remindSwitch.on;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
