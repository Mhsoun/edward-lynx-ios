//
//  ELGoalDetailsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELGoalDetailsViewController.h"

#pragma mark - Private Constants

static CGFloat const kELCategoryViewInitialHeight = 35;
static CGFloat const kELDatePickerViewInitialHeight = 200;

#pragma mark - Class Extension

@interface ELGoalDetailsViewController ()

@property (nonatomic) BOOL hasCreatedGoal;
@property (nonatomic, strong) ELDevelopmentPlanViewManager *viewManager;
@property (nonatomic, strong) ELFormItemGroup *nameGroup;

@end

@implementation ELGoalDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.hasCreatedGoal = NO;
    self.categoryLabel.text = kELNoCategorySelected;
    self.viewManager = [[ELDevelopmentPlanViewManager alloc] init];
    self.nameGroup = [[ELFormItemGroup alloc] initWithInput:self.nameTextField
                                                       icon:nil
                                                 errorLabel:self.nameErrorLabel];
    
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
    
    [self.delegate onGoalAddition:self.goal];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    // Date Picker
    [self.datePicker setBackgroundColor:[UIColor clearColor]];    
    [self.datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
}

#pragma mark - Private Methods

- (void)populatePage {
    self.nameTextField.text = self.goal ? self.goal.title : @"";
    self.datePicker.date = self.goal ? self.goal.dueDate : [NSDate date];
}

#pragma mark - Interface Builder Actions

- (IBAction)onSwitchValueChange:(id)sender {
    UISwitch *switchButton = (UISwitch *)sender;
    
    if ([switchButton isEqual:self.remindSwitch]) {
        self.dateErrorLabel.hidden = YES;
        self.datePickerViewHeightConstraint.constant = switchButton.isOn ? kELDatePickerViewInitialHeight : 0;
        
        [self.datePickerView updateConstraints];
    } else if ([switchButton isEqual:self.categorySwitch]) {
        self.categoryViewHeightConstraint.constant = switchButton.isOn ? kELCategoryViewInitialHeight : 0;
        
        [self.categoryView updateConstraints];
    }
}

- (IBAction)onCategoryButtonClick:(id)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Category Selection"
                                                                        message:@"Select from list of categories"
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    void (^actionBlock)(UIAlertAction *) = ^(UIAlertAction *action) {
        self.categoryLabel.text = action.title;
    };
    
    [controller addAction:[UIAlertAction actionWithTitle:@"Cancel"
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
    NSString *dateString = [[ELAppSingleton sharedInstance].apiDateFormatter stringFromDate:self.datePicker.date];
    NSMutableDictionary *mFormItems = [[NSMutableDictionary alloc] initWithDictionary:@{@"name": self.nameGroup}];
    
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
    
    self.hasCreatedGoal = YES;
    self.goal = [[ELGoal alloc] initWithDictionary:@{@"title": self.nameTextField.text,
                                                     @"description": self.descriptionTextView.text,
                                                     @"checked": @NO,
                                                     @"position": @0,
                                                     @"dueDate": dateString,
                                                     @"reminderSent": @NO}
                                             error:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
