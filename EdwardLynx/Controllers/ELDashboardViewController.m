//
//  ELDashboardViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 16/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDashboardViewController.h"

#pragma mark - Private Constants

static CGFloat const kICornerRadius = 2.0f;

@interface ELDashboardViewController ()

@end

@implementation ELDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods

- (void)layoutPage {
    ELStatusView *view;
    
    // Status section
    view = [[ELStatusView alloc] initWithDetails:@{@"title": @"Development Plan",
                                                   @"details": @"3 out of 4 goals completed"}];
    view.frame = self.devPlanStatusView.frame;
    
    [self.devPlanStatusView addSubview:view];
    [self.devPlanStatusView.layer setCornerRadius:kICornerRadius];
    
    view = [[ELStatusView alloc] initWithDetails:@{@"title": @"Feedback request status",
                                                   @"details": @"3 out of 4 submitted results"}];
    view.frame = self.feedbackStatusView.frame;
    view.layer.cornerRadius = 4.0f;
    
    [self.feedbackStatusView addSubview:view];
    [self.feedbackStatusView.layer setCornerRadius:kICornerRadius];
}

@end
