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
static CGFloat const kELSectionHeight = 17;

static NSString * const kELActionCellIdentifier = @"OptionCell";
static NSString * const kELAddActionCellIdentifier = @"AddOptionCell";

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
    
    [self.tableView registerNib:[UINib nibWithNibName:kELActionCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELActionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:kELAddActionCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELAddActionCellIdentifier];
    
    // Goal details
    [self populatePage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.nameTextField.text.length > 0) {
        return;
    }
    
    [self.nameTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.dropdown reset];
    
    if (!self.hasCreatedGoal) {
        return;
    }
    
    if (self.toAddNew) {
        [self.delegate onGoalAddition:self.goal];
    } else {
        [self.delegate onGoalUpdate:self.goal];
    }
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mActions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id value = self.mActions[indexPath.row];
    
    if ([value isKindOfClass:[NSString class]]) {
        ELAddObjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELAddActionCellIdentifier];
        
        cell.delegate = self;
        
        return cell;
    } else {
        ELGoalAction *action  = (ELGoalAction *)value;
        ELItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELActionCellIdentifier];
        
        cell.tag = indexPath.row;
        cell.delegate = self;
        cell.optionLabel.text = action.title;
//        cell.userInteractionEnabled = !action.isAlreadyAdded;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[ELAddObjectTableViewCell class]]) {
        ELAddObjectTableViewCell *addCell = (ELAddObjectTableViewCell *)cell;
        
        if ([addCell canBecomeFirstResponder]) {
            [addCell becomeFirstResponder];
        }
    }
}

#pragma mark - Protocol Methods (ELAddItem)

- (void)onAddNewItem:(NSString *)item {
    [self addNewActionWithValue:item];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    CGFloat iconHeight = 15;
    NSString *buttonLabel = NSLocalizedString(self.toAddNew ? @"kELDevelopmentPlanGoalButtonAdd" :
                                                              @"kELDevelopmentPlanGoalButtonUpdate", nil);
    
    // Button
    [self.addGoalButton setTitle:buttonLabel forState:UIControlStateNormal];
    [self.addActionButton setImage:[FontAwesome imageWithIcon:fa_plus
                                                    iconColor:[UIColor blackColor]
                                                     iconSize:iconHeight
                                                    imageSize:CGSizeMake(iconHeight, iconHeight)]
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
    NSString *message, *title;
    UIAlertController *alertController;
    ELGoalAction *action = self.mActions[row];
    void (^deleteAPIBlock)(UIAlertAction * _Nonnull action) = ^(UIAlertAction * _Nonnull action) {
        // TODO API call
    };
    
    if (!action.isAlreadyAdded) {
        [self.mActions removeObjectAtIndex:row];
        [self.tableView reloadData];
        [self adjustTableViewSize];
        
        return;
    }
    
    title = NSLocalizedString(@"kELDevelopmentPlanGoalActionCompleteHeaderMessage", nil);
    message = NSLocalizedString(@"kELDevelopmentPlanGoalActionDeleteDetailsMessage", nil);
    alertController = [UIAlertController alertControllerWithTitle:title
                                                          message:[NSString localizedStringWithFormat:message, action.title]
                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELDeleteButton", nil)
                                                        style:UIAlertActionStyleDestructive
                                                      handler:deleteAPIBlock]];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

#pragma mark - Protocol Methods (DZNEmptyDataSet)

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"kELGoalActionsValidationMessage", nil)
                                           attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:14.0f],
                                                        NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

#pragma mark - Private Methods

- (void)addNewActionWithValue:(NSString *)value {
    ELGoalAction *action;
    
    if (value.length == 0) {
        return;
    }
    
    [self.mActions removeObject:@""];
    
    action = [[ELGoalAction alloc] initWithDictionary:@{@"id": @(-1),
                                                        @"title": value,
                                                        @"checked": @NO,
                                                        @"position": @(self.mActions.count)}
                                                error:nil];
    action.isAlreadyAdded = NO;
    
    [self.addActionButton setEnabled:YES];
    [self.mActions addObject:action];
    [self.tableView reloadData];
    [self adjustTableViewSize];
}

- (void)adjustTableViewSize {
    CGFloat tableViewContentSizeHeight = (kELCellHeight * (self.mActions.count == 0 ? 1: self.mActions.count)) + kELCellHeight;
    
    [self.tableViewHeightConstraint setConstant:tableViewContentSizeHeight + kELSectionHeight];
    [self.tableView updateConstraints];
}

- (void)populatePage {
    NSMutableArray *mCategories = [[NSMutableArray alloc] init];
    
    for (ELCategory *category in AppSingleton.categories) [mCategories addObject:category.title];
    
    self.dropdown = [[ELDropdownView alloc] initWithItems:mCategories
                                           baseController:self
                                         defaultSelection:nil];
    
    self.selectedCategory = self.goal ? self.goal.category : (mCategories.count > 0 ? mCategories[0] : @"");
    self.nameTextField.text = self.goal ? self.goal.title : @"";
    self.descriptionTextView.text = self.goal.shortDescription;
    
    // Date
    [self.remindSwitch setOn:self.goal.dueDateChecked];
    [self.datePicker setDate:self.goal && self.goal.dueDate ? self.goal.dueDate : [NSDate date]];
    [self toggleBasedOnSwitchValue:self.remindSwitch];
    
    // Category
    [self.categorySwitch setOn:self.goal.categoryChecked];
    [self.dropdown setFrame:self.dropdownView.bounds];
    [self.dropdown setDefaultValue:self.selectedCategory];
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
    
    self.addActionButton.enabled = NO;
    
    if (self.mActions.count > 0) {
        indexPath = [NSIndexPath indexPathForRow:self.mActions.count - 1 inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell isKindOfClass:[ELAddObjectTableViewCell class]]) {
            [self addNewActionWithValue:cell.textField.text];
        }
    }
    
    [self.mActions addObject:@""];
    [self.tableView reloadData];
    [self adjustTableViewSize];
}

- (IBAction)onAddGoalButtonClick:(id)sender {
    BOOL isValid, hasSelection;
    NSString *dateString;
    NSMutableDictionary *mFormItems, *mGoalDict;
    NSMutableArray *mActions = [[NSMutableArray alloc] init];
    ELFormItemGroup *nameGroup = [[ELFormItemGroup alloc] initWithInput:self.nameTextField
                                                                   icon:nil
                                                             errorLabel:self.nameErrorLabel];
    
    hasSelection = YES;
    
    [self.mActions removeObject:@""];
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (self.mActions.count == 0) {
        [ELUtils presentToastAtView:self.view
                            message:NSLocalizedString(@"kELGoalActionsValidationMessage", nil)
                         completion:nil];
        
        return;
    }
    
    mFormItems = [[NSMutableDictionary alloc] initWithDictionary:@{@"name": nameGroup}];
    mGoalDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"title": self.nameTextField.text,
                                                                  @"description": self.descriptionTextView.text,
                                                                  @"checked": @NO,
                                                                  @"position": @0,
                                                                  @"reminderSent": @NO}];
    
    if (self.remindSwitch.isOn) {
        dateString = [AppSingleton.apiDateFormatter stringFromDate:self.datePicker.date];
        
        [mFormItems setObject:[[ELFormItemGroup alloc] initWithText:dateString
                                                               icon:nil
                                                         errorLabel:self.dateErrorLabel]
                       forKey:@"date"];
        [mGoalDict setObject:dateString forKey:@"dueDate"];
    }
    
    if (self.categorySwitch.isOn) {
        hasSelection = self.dropdown.hasSelection;
    }
    
    isValid = [self.viewManager validateAddGoalFormValues:[mFormItems copy]];
    
    if (!(isValid && hasSelection)) {
        return;
    }
    
    for (ELGoalAction *action in self.mActions) [mActions addObject:[action toDictionary]];
    
    [mGoalDict setObject:[mActions copy] forKey:@"actions"];
    
    self.hasCreatedGoal = YES;
    
    self.goal = [[ELGoal alloc] initWithDictionary:[mGoalDict copy] error:nil];
    self.goal.category = self.selectedCategory;
    self.goal.categoryChecked = self.categorySwitch.on;
    self.goal.dueDateChecked = self.remindSwitch.on;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
