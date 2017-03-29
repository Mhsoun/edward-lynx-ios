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
#import "ELDashboardHeaderTableViewCell.h"
#import "ELDashboardReminderTableViewCell.h"
#import "ELDevelopmentPlanTableViewCell.h"
#import "ELSectionView.h"
#import "ELShortcutView.h"
#import "ELStatusView.h"

#import "ELNotificationView.h"

#pragma mark - Private Constants

//static CGFloat const kELCornerRadius = 5.0f;
static NSString * const kELHeaderCellIdentifier = @"DashboardHeaderCell";
static NSString * const kELDevPlanCellIdentifier = @"DevelopmentPlanCell";
static NSString * const kELReminderCellIdentifier = @"DashboardReminderCell";

#pragma mark - Class Extension

@interface ELDashboardViewController ()

@property (nonatomic, strong) NSDictionary *itemsDict;

@end

@implementation ELDashboardViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    [self sampleData];
    
    AppSingleton.hasLoadedApplication = YES;
    
    // Assign the dashboard as the new root controller
    [ApplicationDelegate assignNewRootViewController:self];
    
    // Register for Remote Notifications
#if !(TARGET_OS_SIMULATOR)
    [self triggerRegisterForNotifications];
    
    if (ApplicationDelegate.notification) {
        [ApplicationDelegate displayViewControllerByData:ApplicationDelegate.notification];
        
        ApplicationDelegate.notification = nil;
    }
#endif
    
    // Table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:kELHeaderCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELHeaderCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:kELReminderCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELReminderCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:kELDevPlanCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELDevPlanCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.itemsDict allKeys].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [self.itemsDict allKeys][section];
    NSArray *items = self.itemsDict[key];
    
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id value;
    NSString *key = [self.itemsDict allKeys][indexPath.section];
    NSArray *items = self.itemsDict[key];
    
    value = items[indexPath.row];
    
    if (indexPath.section == 0) {
        ELDashboardHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELHeaderCellIdentifier
                                                                               forIndexPath:indexPath];
        
        [cell setDelegate:self];
        [cell setupHeaderContent];
        
        return cell;
    } else if (indexPath.section == 1) {
        ELDashboardReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELReminderCellIdentifier
                                                                                 forIndexPath:indexPath];
        
        [cell configure:value atIndexPath:indexPath];
        
        return cell;
    } else {
        ELDevelopmentPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELDevPlanCellIdentifier
                                                                               forIndexPath:indexPath];
        
        [cell configure:value atIndexPath:indexPath];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 175;
            break;
        case 1:
            return 55;
        default:
            return 225;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGFLOAT_MIN : 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ELSectionView *sectionView;
    
    if (section == 0) {
        return nil;
    }
    
    sectionView = [[ELSectionView alloc] initWithTitle:[self.itemsDict allKeys][section]
                                                 frame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 30)
                                         accessSeeMore:section == 2];
    
    return sectionView;
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
//    ELActionView *actionView;
//    ELStatusView *statusView;
//    ELShortcutView *shortcutView;
//    
//    // Status section
//    statusView = [[ELStatusView alloc] initWithDetails:@{@"title": @"Development Plan Status",
//                                                         @"segue": @"",
//                                                         @"details": @"3/4 goals completed",
//                                                         @"permissions": @[@(kELRolePermissionCreateDevelopmentPlan)]}];
//    statusView.frame = self.devPlanStatusView.bounds;
////    statusView.delegate = self;
//    
//    [self.devPlanStatusView addSubview:statusView];
//    [self.devPlanStatusView.layer setCornerRadius:kELCornerRadius];
//    
//    statusView = [[ELStatusView alloc] initWithDetails:@{@"title": @"Feedback request status",
//                                                         @"segue": @"",
//                                                         @"details": @"3/4 submitted results",
//                                                         @"permissions": @[@(kELRolePermissionParticipateInSurvey),
//                                                                           @(kELRolePermissionSubmitSurvey),
//                                                                           @(kELRolePermissionInstantFeedback)]}];
//    statusView.frame = self.feedbackStatusView.bounds;
////    statusView.delegate = self;
//    
//    [self.feedbackStatusView addSubview:statusView];
//    [self.feedbackStatusView.layer setCornerRadius:kELCornerRadius];
//    
//    // Shortcuts section
//    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"Create Instant Feedback",
//                                                             @"segue": @"CreateInstantFeedback",
//                                                             @"description": @"Description on creating instant feedback.",
//                                                             @"permissions": @[@(kELRolePermissionInstantFeedback)]}];
//    shortcutView.frame = self.createFeedbackView.bounds;
//    shortcutView.delegate = self;
//    
//    [self.createFeedbackView addSubview:shortcutView];
//    [self.createFeedbackView.layer setCornerRadius:kELCornerRadius];
//    
//    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"Create Development Plan",
//                                                             @"segue": @"CreateDevelopmentPlan",
//                                                             @"description": @"Description on creating development plan.",
//                                                             @"permissions": @[@(kELRolePermissionCreateDevelopmentPlan)]}];
//    shortcutView.frame = self.createDevPlanView.bounds;
//    shortcutView.delegate = self;
//    
//    [self.createDevPlanView addSubview:shortcutView];
//    [self.createDevPlanView.layer setCornerRadius:kELCornerRadius];
//    
//    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"View Reports",
//                                                             @"segue": @"Report",
//                                                             @"description": @"Description on viewing reports.",
//                                                             @"permissions": @[@(kELRolePermissionViewAnonymousIndividualReports),
//                                                                               @(kELRolePermissionViewAnonymousTeamReports)]}];
//    shortcutView.frame = self.reportsView.bounds;
//    shortcutView.delegate = self;
//    
//    [self.reportsView addSubview:shortcutView];
//    [self.reportsView.layer setCornerRadius:kELCornerRadius];
//    
//    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"View Surveys",
//                                                             @"segue": @"Survey",
//                                                             @"description": @"Description on viewing surveys.",
//                                                             @"permissions": @[@(kELRolePermissionParticipateInSurvey)]}];
//    shortcutView.frame = self.surveysView.bounds;
//    shortcutView.delegate = self;
//    
//    [self.surveysView addSubview:shortcutView];
//    [self.surveysView.layer setCornerRadius:kELCornerRadius];
//    
//    // Action Required section
//    actionView = [[ELActionView alloc] initWithDetails:@{@"value": @"360",
//                                                         @"title": @"Feedback Requests",
//                                                         @"count": @(0),
//                                                         @"segue": @"",
//                                                         @"color": kELGreenColor,
//                                                         @"permissions": @[@(kELRolePermissionParticipateInSurvey),
//                                                                           @(kELRolePermissionSubmitSurvey)]}];
//    actionView.frame = self.feedbackActionView.bounds;
////    actionView.delegate = self;
//    
//    [self.feedbackActionView addSubview:actionView];
//    [self.feedbackActionView.layer setCornerRadius:kELCornerRadius];
//    
//    actionView = [[ELActionView alloc] initWithDetails:@{@"value": @"New",
//                                                         @"title": @"Reports",
//                                                         @"count": @(0),
//                                                         @"segue": @"",
//                                                         @"color": kELBlueColor,
//                                                         @"permissions": @[@(kELRolePermissionViewAnonymousIndividualReports),
//                                                                           @(kELRolePermissionViewAnonymousTeamReports)]}];
//    actionView.frame = self.reportsActionView.bounds;
////    actionView.delegate = self;
//    
//    [self.reportsActionView addSubview:actionView];
//    [self.reportsActionView.layer setCornerRadius:kELCornerRadius];
//    
//    actionView = [[ELActionView alloc] initWithDetails:@{@"value": @"Instant",
//                                                         @"title": @"Feedback Requests",
//                                                         @"count": @(0),
//                                                         @"segue": @"InstantFeedback",
//                                                         @"color": kELPinkColor,
//                                                         @"permissions": @[@(kELRolePermissionInstantFeedback)]}];
//    actionView.frame = self.instantFeedbackActionView.bounds;
//    actionView.delegate = self;
//    
//    [self.instantFeedbackActionView addSubview:actionView];
//    [self.instantFeedbackActionView.layer setCornerRadius:kELCornerRadius];
    
    // Navigation Bar
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Protocol Methods (ELDashboardViewDelegate)

- (void)viewTapToPerformSegueWithIdentifier:(NSString *)identifier {
    [self performSegueWithIdentifier:identifier sender:self];
}

#pragma mark - Private Methods

- (void)sampleData {
    ELReminder *reminder1 = [[ELReminder alloc] initWithDictionary:@{@"id": @(-1),
                                                                    @"title": @"Goal",
                                                                    @"description": @"Read book",
                                                                    @"dueDate": @"2017-01-31T06:54:33+01:00",
                                                                    @"type": @(kELReminderTypeGoal)}
                                                            error:nil];
    ELReminder *reminder2 = [[ELReminder alloc] initWithDictionary:@{@"id": @(-1),
                                                                     @"title": @"Invite Feedback",
                                                                     @"description": @"Providers to your Instant Feedback",
                                                                     @"dueDate": @"2017-01-31T06:54:33+01:00",
                                                                     @"type": @(kELReminderTypeFeedback)}
                                                             error:nil];
    ELDevelopmentPlan *devPlan = [[ELDevelopmentPlan alloc] initWithDictionary:@{@"id": @1,
                                                                                 @"name": @"My first development plan",
                                                                                 @"createdAt": @"2017-01-31T06:54:33+01:00",
                                                                                 @"updatedAt": @"2017-01-31T06:54:33+01:00",
                                                                                 @"goals": @[@{@"id": @1,
                                                                                               @"title": @"Wash the dishes",
                                                                                               @"description": @"",
                                                                                               @"checked": @0,
                                                                                               @"position": @0,
                                                                                               @"dueDate": @"",
                                                                                               @"reminderSent": @0,
                                                                                               @"categoryId": @(-1),
                                                                                               @"actions": @[@{@"id": @33,
                                                                                                               @"title": @"asdasd",
                                                                                                               @"checked": @1,
                                                                                                               @"position": @0}]}]}
                                                                         error:nil];
    
    self.itemsDict = @{@"": @[@""],
                       @"REMINDERS": @[reminder1, reminder2, reminder2, reminder1],
                       @"DEVELOPMENT PLAN": @[devPlan, devPlan]};
}

- (void)triggerRegisterForNotifications {
    if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        [ApplicationDelegate registerDeviceToFirebaseAndAPI];
    } else {
        [ApplicationDelegate registerForRemoteNotifications];
    }
}

@end
