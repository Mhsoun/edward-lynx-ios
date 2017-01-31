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

@end

@implementation ELDevelopmentPlanDetailViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization    
    [self populatePage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
