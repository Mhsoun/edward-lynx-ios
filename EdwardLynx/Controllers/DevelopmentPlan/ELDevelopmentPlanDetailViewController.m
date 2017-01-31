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

@end

@implementation ELDevelopmentPlanDetailViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.hasCreatedGoal = NO;
    
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
    NSDateFormatter *formatter;
    
    // TODO Check for validity
    
    formatter = [ELAppSingleton sharedInstance].dateFormatter;
    formatter.dateFormat = kELAPIDateFormat;
    formatter.timeZone = [NSTimeZone systemTimeZone];
    formatter.locale = [NSLocale systemLocale];
    
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
