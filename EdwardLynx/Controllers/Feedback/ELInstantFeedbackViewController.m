//
//  ELInstantFeedbackViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELInstantFeedbackViewController.h"

#pragma mark - Private Constants

static CGFloat const kELCornerRadius = 4.0f;

#pragma mark - Class Extension

@interface ELInstantFeedbackViewController ()

@end

@implementation ELInstantFeedbackViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    self.questionTypeButton.layer.cornerRadius = kELCornerRadius;
    self.inviteButton.layer.cornerRadius = kELCornerRadius;
}

@end
