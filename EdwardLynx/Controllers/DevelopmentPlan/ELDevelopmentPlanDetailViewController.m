//
//  ELDevelopmentPlanDetailViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDevelopmentPlanDetailViewController.h"

#pragma mark - Class Extension

@interface ELDevelopmentPlanDetailViewController ()

@property (nonatomic) BOOL hasCreatedGoal;
@property (nonatomic, strong) ELDevelopmentPlanViewManager *viewManager;
@property (nonatomic, strong) ELFormItemGroup *nameGroup, *dateGroup;

@end

@implementation ELDevelopmentPlanDetailViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.hasCreatedGoal = NO;
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

- (IBAction)onAddGoalButtonClick:(id)sender {
    BOOL isValid;
    NSDateFormatter *formatter = [ELAppSingleton sharedInstance].dateFormatter;
    
    formatter.dateFormat = kELAPIDateFormat;
    formatter.timeZone = [NSTimeZone systemTimeZone];
    formatter.locale = [NSLocale systemLocale];
    self.dateGroup = [[ELFormItemGroup alloc] initWithText:[formatter stringFromDate:self.datePicker.date]
                                                      icon:nil
                                                errorLabel:self.dateErrorLabel];
    isValid = [self.viewManager validateAddGoalFormValue:@{@"name": self.nameGroup,
                                                           @"date": self.dateGroup}];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (!isValid) {
        return;
    }
    
    self.hasCreatedGoal = YES;
    self.goal = [[ELGoal alloc] initWithDictionary:@{@"title": self.nameTextField.text,
                                                     @"description": @"",
                                                     @"checked": @NO,
                                                     @"position": @0,
                                                     @"dueDate": [formatter stringFromDate:self.datePicker.date],  // 2017-01-31T06:54:33+01:00
                                                     @"reminderSent": @NO}
                                             error:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
