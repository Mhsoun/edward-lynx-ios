//
//  ELDashboardViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 16/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDashboardViewController.h"
#import "AppDelegate.h"
#import "ELDashboardHeaderTableViewCell.h"
#import "ELDashboardReminderTableViewCell.h"
#import "ELDevelopmentPlanTableViewCell.h"
#import "ELDevelopmentPlanDetailsViewController.h"
#import "ELNotificationView.h"
#import "ELSectionView.h"
#import "ELTabPageViewController.h"

#pragma mark - Private Constants

static CGFloat const kELAdsViewHeight = 100;
static NSString * const kELHeaderCellIdentifier = @"DashboardHeaderCell";
static NSString * const kELDevPlanCellIdentifier = @"DevelopmentPlanCell";
static NSString * const kELReminderCellIdentifier = @"DashboardReminderCell";

#pragma mark - Class Extension

@interface ELDashboardViewController ()

@property (nonatomic, strong) id selectedObject;
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
        [cell setupHeaderContentForController:self];
        
        return cell;
    } else if (indexPath.section == 1) {
        ELDashboardReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELReminderCellIdentifier
                                                                                 forIndexPath:indexPath];
        
        [cell configure:value atIndexPath:indexPath];
        
        return cell;
    } else {
        ELDevelopmentPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELDevPlanCellIdentifier
                                                                               forIndexPath:indexPath];
        
        [cell setTableView:self.tableView];
        [cell configure:value atIndexPath:indexPath];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id value;
    ELDevelopmentPlanDetailsViewController *controller;
    NSString *key = [self.itemsDict allKeys][indexPath.section];
    NSArray *items = self.itemsDict[key];
    
    value = items[indexPath.row];
    
    if ([value isKindOfClass:[ELReminder class]]) {
        //
    } else if ([value isKindOfClass:[ELDevelopmentPlan class]]) {
        controller = [[UIStoryboard storyboardWithName:@"DevelopmentPlan" bundle:nil]
                      instantiateViewControllerWithIdentifier:@"DevelopmentPlanDetails"];
        
        controller.devPlan = (ELDevelopmentPlan *)value;
                
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        return;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section != self.itemsDict.count - 1 ? 0 : kELAdsViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGFLOAT_MIN : 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *label;
    
    if (section != self.itemsDict.count - 1) {
        return nil;
    }
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                      0,
                                                      CGRectGetWidth(self.tableView.frame),
                                                      kELAdsViewHeight)];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Lato-Regular" size:12.0];
    label.opaque = YES;
    label.text = @"Space for Ads";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ELSectionView *sectionView;
    NSMutableDictionary *mSectionDict = [NSMutableDictionary dictionaryWithDictionary:@{@"title": [self.itemsDict allKeys][section]}];
    
    if (section == 0) {
        return nil;
    } else if (section == 2) {
        [mSectionDict setObject:@"DevPlan" forKey:@"segue"];
    }
    
    sectionView = [[ELSectionView alloc] initWithDetails:[mSectionDict copy]
                                                   frame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 30)];
    sectionView.delegate = self;
    
    return sectionView;
}

#pragma mark - Protocol Methods (ELDashboardViewDelegate)

- (void)viewTapToPerformSegueWithIdentifier:(NSString *)identifier {
    if ([@[kELDashboardActionTypeCreateDevPlan, kELDashboardActionTypeCreateFeedback] containsObject:identifier]) {
        [self performSegueWithIdentifier:identifier sender:self];
    } else {
        ELTabPageViewController *controller;
        UINavigationController *navController = [[UIStoryboard storyboardWithName:@"TabPage" bundle:nil]
                                                 instantiateInitialViewController];
        
        controller = navController.viewControllers[0];
        controller.type = [identifier isEqualToString:kELDashboardActionTypeReport] ? kELListTypeReports : kELListTypeSurveys;
        controller.tabs = @[@(kELListFilterAll),
                            @(kELListFilterInstantFeedback),
                            @(kELListFilterLynxManagement)];
        
        if ([identifier isEqualToString:kELDashboardActionTypeDevPlan]) {
            controller.type = kELListTypeDevPlan;
            controller.tabs = @[@(kELListFilterAll),
                                @(kELListFilterInProgress),
                                @(kELListFilterCompleted),
                                @(kELListFilterExpired)];
        } else if ([identifier isEqualToString:kELDashboardActionTypeFeedback]) {
            controller.initialIndex = 1;
        } else if ([identifier isEqualToString:kELDashboardActionTypeLynx]) {
            controller.initialIndex = 2;
        } else {
            // NOTE No further action needed
        }
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - Private Methods

- (void)sampleData {
    ELReminder *reminder1 = [[ELReminder alloc] initWithDictionary:@{@"id": @(-1),
                                                                     @"title": @"Goal",
                                                                     @"description": @"Read book",
                                                                     @"dueDate": @"2017-05-31T06:54:33+01:00",
                                                                     @"type": @(kELReminderTypeGoal)}
                                                            error:nil];
    ELReminder *reminder2 = [[ELReminder alloc] initWithDictionary:@{@"id": @(-1),
                                                                     @"title": @"Invite Feedback",
                                                                     @"description": @"Providers to your Instant Feedback",
                                                                     @"dueDate": @"2017-04-10T06:54:33+01:00",
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
                                                                                                               @"position": @0},
                                                                                                             @{@"id": @33,
                                                                                                               @"title": @"asdasd",
                                                                                                               @"checked": @0,
                                                                                                               @"position": @0}]},
                                                                                             @{@"id": @1,
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
                                                                                                               @"position": @0},
                                                                                                             @{@"id": @33,
                                                                                                               @"title": @"asdasd",
                                                                                                               @"checked": @1,
                                                                                                               @"position": @0},
                                                                                                             @{@"id": @33,
                                                                                                               @"title": @"asdasd",
                                                                                                               @"checked": @0,
                                                                                                               @"position": @0}]},
                                                                                             @{@"id": @1,
                                                                                               @"title": @"Wash the dishes",
                                                                                               @"description": @"",
                                                                                               @"checked": @1,
                                                                                               @"position": @0,
                                                                                               @"dueDate": @"",
                                                                                               @"reminderSent": @0,
                                                                                               @"categoryId": @(-1),
                                                                                               @"actions": @[@{@"id": @33,
                                                                                                               @"title": @"asdasd",
                                                                                                               @"checked": @1,
                                                                                                               @"position": @0}]},
                                                                                             @{@"id": @1,
                                                                                               @"title": @"Wash the dishes",
                                                                                               @"description": @"",
                                                                                               @"checked": @0,
                                                                                               @"position": @0,
                                                                                               @"dueDate": @"",
                                                                                               @"reminderSent": @0,
                                                                                               @"categoryId": @(-1),
                                                                                               @"actions": @[@{@"id": @33,
                                                                                                               @"title": @"asdasd",
                                                                                                               @"checked": @0,
                                                                                                               @"position": @0}]},
                                                                                             @{@"id": @1,
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
                                                                                                               @"position": @0},
                                                                                                             @{@"id": @33,
                                                                                                               @"title": @"asdasd",
                                                                                                               @"checked": @0,
                                                                                                               @"position": @0},
                                                                                                             @{@"id": @33,
                                                                                                               @"title": @"asdasd",
                                                                                                               @"checked": @0,
                                                                                                               @"position": @0},
                                                                                                             @{@"id": @33,
                                                                                                               @"title": @"asdasd",
                                                                                                               @"checked": @0,
                                                                                                               @"position": @0}]},
                                                                                             @{@"id": @1,
                                                                                               @"title": @"Wash the dishes",
                                                                                               @"description": @"",
                                                                                               @"checked": @1,
                                                                                               @"position": @0,
                                                                                               @"dueDate": @"",
                                                                                               @"reminderSent": @0,
                                                                                               @"categoryId": @(-1),
                                                                                               @"actions": @[@{@"id": @33,
                                                                                                               @"title": @"asdasd",
                                                                                                               @"checked": @1,
                                                                                                               @"position": @0}]},
                                                                                             @{@"id": @1,
                                                                                               @"title": @"Wash the dishes",
                                                                                               @"description": @"",
                                                                                               @"checked": @1,
                                                                                               @"position": @0,
                                                                                               @"dueDate": @"",
                                                                                               @"reminderSent": @0,
                                                                                               @"categoryId": @(-1),
                                                                                               @"actions": @[@{@"id": @33,
                                                                                                               @"title": @"asdasd",
                                                                                                               @"checked": @1,
                                                                                                               @"position": @0}]}]}
                                                                         error:nil];
    ELDevelopmentPlan *devPlan1 = [[ELDevelopmentPlan alloc] initWithDictionary:@{@"id": @1,
                                                                                  @"name": @"My first development plan",
                                                                                  @"createdAt": @"2017-01-31T06:54:33+01:00",
                                                                                  @"updatedAt": @"2017-01-31T06:54:33+01:00",
                                                                                  @"goals": @[@{@"id": @1,
                                                                                                @"title": @"Wash the dishes",
                                                                                                @"description": @"",
                                                                                                @"checked": @1,
                                                                                                @"position": @0,
                                                                                                @"dueDate": @"",
                                                                                                @"reminderSent": @0,
                                                                                                @"categoryId": @(-1),
                                                                                                @"actions": @[@{@"id": @33,
                                                                                                                @"title": @"asdasd",
                                                                                                                @"checked": @1,
                                                                                                                @"position": @0}]},
                                                                                              @{@"id": @1,
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
                                                                                                                @"position": @0},
                                                                                                              @{@"id": @33,
                                                                                                                @"title": @"asdasd",
                                                                                                                @"checked": @1,
                                                                                                                @"position": @0},
                                                                                                              @{@"id": @33,
                                                                                                                @"title": @"asdasd",
                                                                                                                @"checked": @0,
                                                                                                                @"position": @0}]},
                                                                                              @{@"id": @1,
                                                                                                @"title": @"Wash the dishes",
                                                                                                @"description": @"",
                                                                                                @"checked": @1,
                                                                                                @"position": @0,
                                                                                                @"dueDate": @"",
                                                                                                @"reminderSent": @0,
                                                                                                @"categoryId": @(-1),
                                                                                                @"actions": @[@{@"id": @33,
                                                                                                                @"title": @"asdasd",
                                                                                                                @"checked": @1,
                                                                                                                @"position": @0},
                                                                                                              @{@"id": @33,
                                                                                                                @"title": @"asdasd",
                                                                                                                @"checked": @1,
                                                                                                                @"position": @0}]}]}
                                                                         error:nil];
    
    self.itemsDict = @{@"": @[@""],
                       @"REMINDERS": @[reminder1, reminder2, reminder2, reminder1],
                       @"DEVELOPMENT PLAN": @[devPlan, devPlan1]};
}

- (void)triggerRegisterForNotifications {
    if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        [ApplicationDelegate registerDeviceToFirebaseAndAPI];
    } else {
        [ApplicationDelegate registerForRemoteNotifications];
    }
}

@end
