//
//  ELGoalDetailsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELGoalDetailsViewController.h"

#pragma mark - Class Extension

@interface ELGoalDetailsViewController ()

@property (nonatomic) BOOL hasCreatedGoal;
@property (nonatomic, strong) ELDevelopmentPlanViewManager *viewManager;
@property (nonatomic, strong) ELFormItemGroup *nameGroup, *dateGroup;

@end

@implementation ELGoalDetailsViewController

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
    NSString *dateString = [[ELAppSingleton sharedInstance].apiDateFormatter stringFromDate:self.datePicker.date];
    
    self.dateGroup = [[ELFormItemGroup alloc] initWithText:dateString
                                                      icon:nil
                                                errorLabel:self.dateErrorLabel];
    isValid = [self.viewManager validateAddGoalFormValues:@{@"name": self.nameGroup,
                                                            @"date": self.dateGroup}];
    
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
