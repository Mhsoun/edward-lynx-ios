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
    ELActionView *actionView;
    ELStatusView *statusView;
    ELShortcutView *shortcutView;
    
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
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"Create Instant Feedback"}];
    shortcutView.frame = self.createFeedbackView.frame;
    
    [self.createFeedbackView addSubview:shortcutView];
    [self.createFeedbackView.layer setCornerRadius:kICornerRadius];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"Create Development Plan"}];
    shortcutView.frame = self.createDevPlanView.frame;
    
    [self.createDevPlanView addSubview:shortcutView];
    [self.createDevPlanView.layer setCornerRadius:kICornerRadius];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"View Reports"}];
    shortcutView.frame = self.reportsView.frame;
    
    [self.reportsView addSubview:shortcutView];
    [self.reportsView.layer setCornerRadius:kICornerRadius];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"View Surveys"}];
    shortcutView.frame = self.surveysView.frame;
    
    [self.surveysView addSubview:shortcutView];
    [self.surveysView.layer setCornerRadius:kICornerRadius];
    
    // Action Required section
    actionView = [[ELActionView alloc] initWithDetails:@{@"value": @"99",
                                                         @"title": @"360 Feedback Requests"}];
    actionView.frame = self.feedbackActionView.frame;
    
    [self.feedbackActionView addSubview:actionView];
    [self.feedbackActionView.layer setCornerRadius:kICornerRadius];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"value": @"99",
                                                         @"title": @"360 Feedback Requests"}];
    actionView.frame = self.feedbackActionView.frame;
    
    [self.feedbackActionView addSubview:actionView];
    [self.feedbackActionView.layer setCornerRadius:kICornerRadius];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"value": @"2",
                                                         @"title": @"Reports"}];
    actionView.frame = self.reportsActionView.frame;
    
    [self.reportsActionView addSubview:actionView];
    [self.reportsActionView.layer setCornerRadius:kICornerRadius];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"value": @"0",
                                                         @"title": @"Instant Feedback"}];
    actionView.frame = self.instantFeedbackActionView.frame;
    
    [self.instantFeedbackActionView addSubview:actionView];
    [self.instantFeedbackActionView.layer setCornerRadius:kICornerRadius];
}

@end
