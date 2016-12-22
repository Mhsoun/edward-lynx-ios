//
//  ELDashboardViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 16/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDashboardViewController.h"

#pragma mark - Private Constants

static CGFloat const kELCornerRadius = 2.0f;

@interface ELDashboardViewController ()

@end

@implementation ELDashboardViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // TEMP
    [[[ELUsersAPIClient alloc] init] userInfoWithCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ELAppSingleton sharedInstance] setUser:[[ELUser alloc] initWithDictionary:responseDict
                                                                                  error:nil]];
        });
    }];
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
    [self.devPlanStatusView.layer setCornerRadius:kELCornerRadius];
    
    statusView = [[ELStatusView alloc] initWithDetails:@{@"title": @"Feedback request status",
                                                         @"details": @"3 out of 4 submitted results"}];
    statusView.frame = self.feedbackStatusView.frame;
    statusView.layer.cornerRadius = 4.0f;
    
    [self.feedbackStatusView addSubview:statusView];
    [self.feedbackStatusView.layer setCornerRadius:kELCornerRadius];
    
    // Shortcuts section
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"Create Instant Feedback"}];
    shortcutView.frame = self.createFeedbackView.frame;
    
    [self.createFeedbackView addSubview:shortcutView];
    [self.createFeedbackView.layer setCornerRadius:kELCornerRadius];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"Create Development Plan"}];
    shortcutView.frame = self.createDevPlanView.frame;
    
    [self.createDevPlanView addSubview:shortcutView];
    [self.createDevPlanView.layer setCornerRadius:kELCornerRadius];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"View Reports"}];
    shortcutView.frame = self.reportsView.frame;
    
    [self.reportsView addSubview:shortcutView];
    [self.reportsView.layer setCornerRadius:kELCornerRadius];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"View Surveys"}];
    shortcutView.frame = self.surveysView.frame;
    
    [self.surveysView addSubview:shortcutView];
    [self.surveysView.layer setCornerRadius:kELCornerRadius];
    
    // Action Required section
    actionView = [[ELActionView alloc] initWithDetails:@{@"value": @"99",
                                                         @"title": @"360 Feedback Requests"}];
    actionView.frame = self.feedbackActionView.frame;
    
    [self.feedbackActionView addSubview:actionView];
    [self.feedbackActionView.layer setCornerRadius:kELCornerRadius];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"value": @"99",
                                                         @"title": @"360 Feedback Requests"}];
    actionView.frame = self.feedbackActionView.frame;
    
    [self.feedbackActionView addSubview:actionView];
    [self.feedbackActionView.layer setCornerRadius:kELCornerRadius];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"value": @"2",
                                                         @"title": @"Reports"}];
    actionView.frame = self.reportsActionView.frame;
    
    [self.reportsActionView addSubview:actionView];
    [self.reportsActionView.layer setCornerRadius:kELCornerRadius];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"value": @"0",
                                                         @"title": @"Instant Feedback"}];
    actionView.frame = self.instantFeedbackActionView.frame;
    
    [self.instantFeedbackActionView addSubview:actionView];
    [self.instantFeedbackActionView.layer setCornerRadius:kELCornerRadius];
}

@end
