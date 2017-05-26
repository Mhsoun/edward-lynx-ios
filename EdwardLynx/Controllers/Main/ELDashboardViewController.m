//
//  ELDashboardViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 16/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDashboardViewController.h"
#import "AppDelegate.h"
#import "ELDashboardData.h"
#import "ELDashboardHeaderTableViewCell.h"
#import "ELDashboardReminderTableViewCell.h"
#import "ELDevelopmentPlanTableViewCell.h"
#import "ELDevelopmentPlanDetailsViewController.h"
#import "ELNotificationView.h"
#import "ELSectionView.h"
#import "ELSurveysViewController.h"
#import "ELTabPageViewController.h"
#import "ELUsersAPIClient.h"

#pragma mark - Private Constants

static CGFloat const kELAdsViewHeight = 100;
static NSString * const kELHeaderCellIdentifier = @"DashboardHeaderCell";
static NSString * const kELDevPlanCellIdentifier = @"DevelopmentPlanCell";
static NSString * const kELReminderCellIdentifier = @"DashboardReminderCell";

#pragma mark - Class Extension

@interface ELDashboardViewController ()

@property (nonatomic, strong) id selectedObject;
@property (nonatomic, strong) ELDashboardData *dashboardData;

@end

@implementation ELDashboardViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    AppSingleton.hasLoadedApplication = YES;
    
    // Table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:kELHeaderCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELHeaderCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:kELReminderCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELReminderCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:kELDevPlanCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELDevPlanCellIdentifier];
    
    // Register for Remote Notifications
#if !(TARGET_OS_SIMULATOR)
    [self triggerRegisterForNotifications];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // Prepare for loading
    [self.tableView setHidden:YES];
    [self.indicatorView startAnimating];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
#if !(TARGET_OS_SIMULATOR)
    if (ApplicationDelegate.notification) {
        [ApplicationDelegate displayViewControllerByData:ApplicationDelegate.notification];
        
        return;
    }
    
    if (ApplicationDelegate.emailInfoDict) {
        [ApplicationDelegate displayViewControllerByData:ApplicationDelegate.emailInfoDict];
        
        return;
    }
#endif
    
    // Load Dashboard details
    [self loadDashboardData];
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kELDashboardActionTypeInvite]) {
        ELSurveysViewController *controller = (ELSurveysViewController *)[segue destinationViewController];
        
        controller.toInvite = YES;
    }
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dashboardData sections].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [self.dashboardData sections][section];
    NSArray *items = (NSArray *)[self.dashboardData itemsForSection:key];
    
    return section == 0 ? 1 : items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id value;
    NSString *key = [self.dashboardData sections][indexPath.section];
    NSArray *items = (NSArray *)[self.dashboardData itemsForSection:key];
    
    value = items[indexPath.row];
    
    if (indexPath.section == 0) {
        ELDashboardHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELHeaderCellIdentifier
                                                                               forIndexPath:indexPath];
        
        [cell setDelegate:self];
        [cell setupHeaderContent:items controller:self];
        
        return cell;
    } else if ([value isKindOfClass:[ELReminder class]]) {
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
    NSString *key = [self.dashboardData sections][indexPath.section];
    NSArray *items = (NSArray *)[self.dashboardData itemsForSection:key];
    
    value = items[indexPath.row];
    
    if ([value isKindOfClass:[ELReminder class]]) {
        NSString *identifier, *storyboard;
        __kindof ELBaseDetailViewController *controller;
        ELReminder *reminder = (ELReminder *)value;
        
        switch (reminder.type) {
            case kELReminderTypeFeedback:
                storyboard = @"InstantFeedback";
                
                break;
            case kELReminderTypeGoal:
                storyboard = @"DevelopmentPlan";
                
                break;
            default:
                storyboard = @"Survey";
                
                break;
        }
        
        identifier = [NSString stringWithFormat:@"%@Details", storyboard];
        controller = [[UIStoryboard storyboardWithName:storyboard bundle:nil]
                      instantiateViewControllerWithIdentifier:identifier];
        controller.objectId = reminder.objectId;
        
        [self.navigationController pushViewController:controller animated:YES];
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
    id value;
    NSString *key = [self.dashboardData sections][indexPath.section];
    NSArray *items = (NSArray *)[self.dashboardData itemsForSection:key];
    
    value = items[indexPath.row];
    
    if (indexPath.section == 0) {
        return IDIOM == UIUserInterfaceIdiomPad ? 250 : 175;
    }
    
    return [value isKindOfClass:[ELReminder class]] ? 55 : 225;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // NOTE Removed ads section for now
//    return section != [self.dashboardData sections].count - 1 ? 0 : kELAdsViewHeight;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGFLOAT_MIN : 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // NOTE Removed ads section for now
//    UILabel *label;
//    
//    if (section != [self.dashboardData sections].count - 1) {
//        return nil;
//    }
//    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
//                                                      CGRectGetWidth(self.tableView.frame),
//                                                      kELAdsViewHeight)];
//    
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont fontWithName:@"Lato-Regular" size:11.0];
//    label.opaque = YES;
//    label.text = @"";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor];
//    
//    return label;
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ELSectionView *sectionView;
    NSString *key = [self.dashboardData sections][section];
    NSMutableDictionary *mSectionDict = [NSMutableDictionary dictionaryWithDictionary:@{@"title": key}];
    
    if (section == 0) {
        return nil;
    } else if ([key isEqualToString:NSLocalizedString(@"kELDashboardSectionDevelopmentPlans", nil)]) {
        [mSectionDict setObject:kELDashboardActionTypeDevPlan forKey:@"segue"];
    }
    
    sectionView = [[ELSectionView alloc] initWithDetails:[mSectionDict copy]
                                                   frame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 30)];
    sectionView.delegate = self;
    
    return sectionView;
}

#pragma mark - Protocol Methods (ELDashboardViewDelegate)

- (void)viewTapToPerformControllerPushWithIdentifier:(NSString *)identifier {
    if ([@[kELDashboardActionTypeAnswer,
           kELDashboardActionTypeInvite,
           kELDashboardActionTypeCreateDevPlan,
           kELDashboardActionTypeCreateFeedback] containsObject:identifier]) {
        [self performSegueWithIdentifier:identifier sender:self];
    } else {
        ELTabPageViewController *controller;
        UINavigationController *navController = [[UIStoryboard storyboardWithName:@"TabPage" bundle:nil]
                                                 instantiateInitialViewController];
        
        controller = navController.viewControllers[0];
        
        if ([identifier isEqualToString:kELDashboardActionTypeDevPlan]) {
            controller.type = kELListTypeDevPlan;
        } else if ([identifier isEqualToString:kELDashboardActionTypeReport]) {
            controller.type = kELListTypeReports;
        } else {
            controller.type = kELListTypeSurveys;
        }
        
        controller.tabs = @[@(kELListFilterAll),
                            @(kELListFilterInstantFeedback),
                            @(kELListFilterLynxMeasurement)];
        
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
        }
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - Private Methods

- (void)loadDashboardData {
    __weak typeof(self) weakSelf = self;
    
    [[[ELUsersAPIClient alloc] init] dashboardDataWithCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = responseDict;
            
            [weakSelf.indicatorView stopAnimating];
            
            if (error) {
                dict = @{@"answerableCount": @0,
                         @"reminders": @[],
                         @"developmentPlans": @[]};
            }
            
            weakSelf.dashboardData = [[ELDashboardData alloc] initWithDictionary:dict error:nil];
            
            [weakSelf.tableView setHidden:NO];
            [weakSelf.tableView reloadData];
        });
    }];
}

- (void)triggerRegisterForNotifications {
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    NSString *deviceToken = [ELUtils getUserDefaultsValueForKey:kELDeviceTokenUserDefaultsKey];
    
    if (([[UIApplication sharedApplication] isRegisteredForRemoteNotifications] || settings.types & UIUserNotificationTypeAlert) &&
        (deviceToken && deviceToken.length > 0)) {
        [ApplicationDelegate registerDeviceToFirebaseAndAPI];
    } else {
        [ApplicationDelegate registerForRemoteNotifications];
    }
}

@end
