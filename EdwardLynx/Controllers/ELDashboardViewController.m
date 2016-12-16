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
    ELStatusView *statusView;
    ELShortcutsView *shortcutsView;
    
    // Status section
    statusView = [[ELStatusView alloc] initWithDetails:@{@"title": @"Development Plan",
                                                         @"details": @"3 out of 4 goals completed"}];
    statusView.frame = self.devPlanStatusView.frame;
    
    [self.devPlanStatusView addSubview:statusView];
    [self.devPlanStatusView.layer setCornerRadius:kICornerRadius];
    
    statusView = [[ELStatusView alloc] initWithDetails:@{@"title": @"Feedback request status",
                                                         @"details": @"3 out of 4 submitted results"}];
    statusView.frame = self.feedbackStatusView.frame;
    statusView.layer.cornerRadius = 4.0f;
    
    [self.feedbackStatusView addSubview:statusView];
    [self.feedbackStatusView.layer setCornerRadius:kICornerRadius];
    
    // Shortcuts section
    shortcutsView = [[ELShortcutsView alloc] initWithDetails:@{@"title": @"Create Instant Feedback"}];
    shortcutsView.frame = self.createFeedbackView.frame;
    
    [self.createFeedbackView addSubview:shortcutsView];
    [self.createFeedbackView.layer setCornerRadius:kICornerRadius];
    
    shortcutsView = [[ELShortcutsView alloc] initWithDetails:@{@"title": @"Create Development Plan"}];
    shortcutsView.frame = self.createDevPlanView.frame;
    
    [self.createDevPlanView addSubview:shortcutsView];
    [self.createDevPlanView.layer setCornerRadius:kICornerRadius];
    
    shortcutsView = [[ELShortcutsView alloc] initWithDetails:@{@"title": @"View Reports"}];
    shortcutsView.frame = self.reportsView.frame;
    
    [self.reportsView addSubview:shortcutsView];
    [self.reportsView.layer setCornerRadius:kICornerRadius];
    
    shortcutsView = [[ELShortcutsView alloc] initWithDetails:@{@"title": @"View Surveys"}];
    shortcutsView.frame = self.surveysView.frame;
    
    [self.surveysView addSubview:shortcutsView];
    [self.surveysView.layer setCornerRadius:kICornerRadius];
}

@end
