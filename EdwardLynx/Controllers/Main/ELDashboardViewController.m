//
//  ELDashboardViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 16/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDashboardViewController.h"
#import "AppDelegate.h"
#import "ELActionView.h"
#import "ELShortcutView.h"
#import "ELStatusView.h"

#pragma mark - Private Constants

static CGFloat const kELCornerRadius = 5.0f;

#pragma mark - Class Extension

@interface ELDashboardViewController ()

@property (nonatomic, strong) AppDelegate *delegate;

@end

@implementation ELDashboardViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [ELAppSingleton sharedInstance].hasLoadedApplication = YES;
    
    // Assign the dashboard as the new root controller
    [self.delegate assignNewRootViewController:self];
    
    // Register for Remote Notifications
#if !(TARGET_OS_SIMULATOR)
    [self triggerRegisterForNotifications];
    
    if (self.delegate.notification) {
        [self.delegate displayViewControllerByNotification:self.delegate.notification];
        
        self.delegate.notification = nil;
    }
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    ELActionView *actionView;
    ELStatusView *statusView;
    ELShortcutView *shortcutView;
    
    // Status section
    statusView = [[ELStatusView alloc] initWithDetails:@{@"title": @"Development Plan Status",
                                                         @"segue": @"",
                                                         @"details": @"3/4 goals completed",
                                                         @"permissions": @[@(kELRolePermissionCreateDevelopmentPlan)]}];
    statusView.frame = self.devPlanStatusView.frame;
//    statusView.delegate = self;
    
    [self.devPlanStatusView addSubview:statusView];
    [self.devPlanStatusView.layer setCornerRadius:kELCornerRadius];
    
    statusView = [[ELStatusView alloc] initWithDetails:@{@"title": @"Feedback request status",
                                                         @"segue": @"",
                                                         @"details": @"3/4 submitted results",
                                                         @"permissions": @[@(kELRolePermissionParticipateInSurvey),
                                                                           @(kELRolePermissionSubmitSurvey),
                                                                           @(kELRolePermissionInstantFeedback)]}];
    statusView.frame = self.feedbackStatusView.frame;
//    statusView.delegate = self;
    
    [self.feedbackStatusView addSubview:statusView];
    [self.feedbackStatusView.layer setCornerRadius:kELCornerRadius];
    
    // Shortcuts section
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"Create Instant Feedback",
                                                             @"segue": @"CreateInstantFeedback",
                                                             @"description": @"Description on creating instant feedback.",
                                                             @"permissions": @[@(kELRolePermissionInstantFeedback)]}];
    shortcutView.frame = self.createFeedbackView.frame;
    shortcutView.delegate = self;
    
    [self.createFeedbackView addSubview:shortcutView];
    [self.createFeedbackView.layer setCornerRadius:kELCornerRadius];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"Create Development Plan",
                                                             @"segue": @"CreateDevelopmentPlan",
                                                             @"description": @"Description on creating development plan.",
                                                             @"permissions": @[@(kELRolePermissionCreateDevelopmentPlan)]}];
    shortcutView.frame = self.createDevPlanView.frame;
    shortcutView.delegate = self;
    
    [self.createDevPlanView addSubview:shortcutView];
    [self.createDevPlanView.layer setCornerRadius:kELCornerRadius];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"View Reports",
                                                             @"segue": @"Report",
                                                             @"description": @"Description on viewing reports.",
                                                             @"permissions": @[@(kELRolePermissionViewAnonymousIndividualReports),
                                                                               @(kELRolePermissionViewAnonymousTeamReports)]}];
    shortcutView.frame = self.reportsView.frame;
    shortcutView.delegate = self;
    
    [self.reportsView addSubview:shortcutView];
    [self.reportsView.layer setCornerRadius:kELCornerRadius];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"View Surveys",
                                                             @"segue": @"Survey",
                                                             @"description": @"Description on viewing surveys.",
                                                             @"permissions": @[@(kELRolePermissionParticipateInSurvey)]}];
    shortcutView.frame = self.surveysView.frame;
    shortcutView.delegate = self;
    
    [self.surveysView addSubview:shortcutView];
    [self.surveysView.layer setCornerRadius:kELCornerRadius];
    
    // Action Required section
    actionView = [[ELActionView alloc] initWithDetails:@{@"value": @"360",
                                                         @"title": @"Feedback Requests",
                                                         @"count": @(0),
                                                         @"segue": @"",
                                                         @"color": kELGreenColor,
                                                         @"permissions": @[@(kELRolePermissionParticipateInSurvey),
                                                                           @(kELRolePermissionSubmitSurvey)]}];
    actionView.frame = self.feedbackActionView.frame;
//    actionView.delegate = self;
    
    [self.feedbackActionView addSubview:actionView];
    [self.feedbackActionView.layer setCornerRadius:kELCornerRadius];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"value": @"New",
                                                         @"title": @"Reports",
                                                         @"count": @(0),
                                                         @"segue": @"",
                                                         @"color": kELBlueColor,
                                                         @"permissions": @[@(kELRolePermissionViewAnonymousIndividualReports),
                                                                           @(kELRolePermissionViewAnonymousTeamReports)]}];
    actionView.frame = self.reportsActionView.frame;
//    actionView.delegate = self;
    
    [self.reportsActionView addSubview:actionView];
    [self.reportsActionView.layer setCornerRadius:kELCornerRadius];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"value": @"Instant",
                                                         @"title": @"Feedback Requests",
                                                         @"count": @(0),
                                                         @"segue": @"InstantFeedback",
                                                         @"color": kELPinkColor,
                                                         @"permissions": @[@(kELRolePermissionInstantFeedback)]}];
    actionView.frame = self.instantFeedbackActionView.frame;
    actionView.delegate = self;
    
    [self.instantFeedbackActionView addSubview:actionView];
    [self.instantFeedbackActionView.layer setCornerRadius:kELCornerRadius];
}

#pragma mark - Protocol Methods (ELDashboardViewDelegate)

- (void)viewTapToPerformSegueWithIdentifier:(NSString *)identifier {
    [self performSegueWithIdentifier:identifier sender:self];
}

#pragma mark - Private Methods

- (void)triggerRegisterForNotifications {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        [delegate registerDeviceToFirebaseAndAPI];
    } else {
        [delegate registerForRemoteNotifications];
    }
}

@end
