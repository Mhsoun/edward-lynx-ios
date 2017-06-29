//
//  ELManagerIndividualViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "ELManagerIndividualViewController.h"
#import "ELDevelopmentPlan.h"
#import "ELDevelopmentPlanDetailsViewController.h"
#import "ELManagerIndividualTableViewCell.h"
#import "ELTabPageViewController.h"
#import "ELTeamViewManager.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"ManagerIndividualCell";
static NSString * const kELSegueIdentifier = @"DisplayUsers";

#pragma mark - Class Extension

@interface ELManagerIndividualViewController ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) ELTeamViewManager *viewManager;

@end

@implementation ELManagerIndividualViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.viewManager = [[ELTeamViewManager alloc] init];
    self.viewManager.delegate = self;
    
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.emptyDataSetSource = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = ThemeColor(kELSurveySeparatorColor);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    RegisterNib(self.tableView, kELCellIdentifier);
    
    [self reloadPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (AppSingleton.needsPageReload) {
        [self reloadPage];
    }
    
    [super viewDidAppear:animated];
    
    // Observers
    [NotificationCenter addObserver:self
                           selector:@selector(onChartSelection:)
                               name:kELTeamChartSelectionNotification
                             object:nil];
    [NotificationCenter addObserver:self
                           selector:@selector(onSeeMore:)
                               name:kELTeamSeeMoreNotification
                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Remove observers
    [NotificationCenter removeObserver:self
                                  name:kELTeamChartSelectionNotification
                                object:nil];
    [NotificationCenter removeObserver:self
                                  name:kELTeamSeeMoreNotification
                                object:nil];
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELManagerIndividualTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                             forIndexPath:indexPath];
    
    [cell configure:self.items[indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    [self.displayUsersButton.imageView setClipsToBounds:NO];
    [self.displayUsersButton setImage:[FontAwesome imageWithIcon:fa_user_plus
                                                       iconColor:[UIColor blackColor]
                                                        iconSize:15
                                                       imageSize:CGSizeMake(20, 20)]
                             forState:UIControlStateNormal];
}

#pragma mark - Protocol Methods (ELTeamViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [self.indicatorView stopAnimating];
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDetailsPageLoadError", nil)
                     completion:nil];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    self.items = responseDict[@"items"];
    
    [self.indicatorView stopAnimating];
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
}

#pragma mark - Protocol Methods (DZNEmptyDataSet)

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attributes = @{NSFontAttributeName: Font(@"Lato-Regular", 18.0f),
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"kELInviteUsersRetrievalEmpty", nil)
                                           attributes:attributes];
}

#pragma mark - Protocol Methods (XLPagerTabStrip)

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController {
    return [NSLocalizedString(@"kELTabTitleIndividual", nil) uppercaseString];
}

#pragma mark - Private Methods

- (void)reloadPage {
    // Prepare for loading
    [self.tableView setHidden:YES];
    [self.indicatorView startAnimating];
    
    [self.viewManager processRetrieveSharedUserDevPlans];
    
    AppSingleton.needsPageReload = NO;
}

#pragma mark - Selectors

- (void)onSeeMore:(NSNotification *)notification {
    UINavigationController *navController = StoryboardController(@"TabPage", nil);
    ELTabPageViewController *controller = navController.viewControllers[0];
    
    controller.type = kELListTypeDevPlan;
    controller.tabs = @[@(kELListFilterAll),
                        @(kELListFilterInProgress),
                        @(kELListFilterCompleted),
                        @(kELListFilterExpired)];
    
    AppSingleton.devPlanUserId = [notification.userInfo[@"id"] intValue];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onChartSelection:(NSNotification *)notification {
    ELDevelopmentPlanDetailsViewController *controller = StoryboardController(@"DevelopmentPlan",
                                                                              @"DevelopmentPlanDetails");
    
    controller.objectId = [notification.userInfo[@"id"] intValue];
    AppSingleton.devPlanUserId = [notification.userInfo[@"userId"] intValue];
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Interface Builder Actions

- (IBAction)onDisplayUsersButtonClick:(id)sender {
    [self performSegueWithIdentifier:kELSegueIdentifier sender:self];
}

@end
