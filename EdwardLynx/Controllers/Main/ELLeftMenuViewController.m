//
//  ELLeftMenuViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 19/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELLeftMenuViewController.h"
#import "ELBaseViewController.h"
#import "ELDataProvider.h"
#import "ELMenuItem.h"
#import "ELTableDataSource.h"
#import "ELTabPageViewController.h"

#pragma mark - Private Constants

static int const kELDefaultRowIndex = 0;
static NSString * const kELCellIdentifier = @"MenuItemCell";

#pragma mark - Class Extension

@interface ELLeftMenuViewController ()

@property (nonatomic, strong) NSIndexPath *prevIndexPath;
@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) ELDataProvider<ELMenuItem *> *provider;

@end

@implementation ELLeftMenuViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.prevIndexPath = [NSIndexPath indexPathForRow:kELDefaultRowIndex inSection:0];
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:[self menuItems]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    
    // UI additions
    [self layoutPage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView selectRowAtIndexPath:self.prevIndexPath
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    self.tableView.backgroundColor = [[RNThemeManager sharedManager] colorForKey:kELDarkVioletColor];
    self.tableView.separatorColor = [[RNThemeManager sharedManager] colorForKey:kELVioletColor];
}

#pragma mark - Protocol Methods (UITableView)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *segueIdentifier = [(ELMenuItem *)[self.provider rowObjectAtIndexPath:indexPath] segueIdentifier];
    
    if ([segueIdentifier isEqualToString:@"Logout"]) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"kELLogoutButton", nil)
                                                                            message:kELLogoutAlertMessage
                                                                     preferredStyle:UIAlertControllerStyleAlert];
        
        [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELLogoutButton", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
            // Remove auth header
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kELAuthInstanceUserDefaultsKey];
            
            [self presentViewController:[[UIStoryboard storyboardWithName:@"Authentication" bundle:nil]
                                         instantiateInitialViewController]
                               animated:YES
                             completion:nil];
        }]];
        [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView selectRowAtIndexPath:self.prevIndexPath
                                        animated:NO
                                  scrollPosition:UITableViewScrollPositionNone];
        }]];
        
        [self presentViewController:controller
                           animated:YES
                         completion:nil];
    } else {
        self.prevIndexPath = indexPath;
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:self.prevIndexPath];
}

#pragma mark - Protocol Methods (SASlideMenu)

- (void)configureMenuButton:(UIButton *)menuButton {
    UIImage *image = [[UIImage imageNamed:@"Menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [menuButton setFrame:CGRectMake(0, 0, 25, 20)];
    [menuButton setImage:image forState:UIControlStateNormal];
    [menuButton setTintColor:[UIColor whiteColor]];
}

- (Boolean)disablePanGestureForIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)prepareForSwitchToContentViewController:(UINavigationController *)content {
    ELTabPageViewController *controller;
    
    if (self.selectedIndexPath.row == 1) {  // TEMP Condition (Dev Plan)
        controller = content.viewControllers[0];
        controller.type = kELListTypeDevPlan;
        controller.tabs = @[@(kELListFilterAll),
                            @(kELListFilterInProgress),
                            @(kELListFilterCompleted),
                            @(kELListFilterExpired)];
    }
}

- (NSString *)segueIdForIndexPath:(NSIndexPath *)indexPath {
    return [(ELMenuItem *)[self.provider rowObjectAtIndexPath:indexPath] segueIdentifier];
}

- (NSIndexPath *)selectedIndexPath {
    return self.prevIndexPath;
}

#pragma mark - Private Methods

- (NSArray *)menuItems {
    NSDictionary *detailDict;
    NSMutableArray *mItems = [[NSMutableArray alloc] init];
    
    detailDict = @{@"name": NSLocalizedString(@"kELDashboardItemDashboard", nil),
                   @"segueIdentifier": @"Dashboard"};
    
    [mItems addObject:[[ELMenuItem alloc] initWithDictionary:detailDict error:nil]];
    
    detailDict = @{@"name": NSLocalizedString(@"kELDashboardItemDevelopmentPlan", nil),
                   @"segueIdentifier": @"DevelopmentPlan"};
    
    [mItems addObject:[[ELMenuItem alloc] initWithDictionary:detailDict error:nil]];
    
    detailDict = @{@"name": NSLocalizedString(@"kELDashboardItemProfile", nil),
                   @"segueIdentifier": @"Profile"};
    
    [mItems addObject:[[ELMenuItem alloc] initWithDictionary:detailDict error:nil]];
    
    detailDict = @{@"name": NSLocalizedString(@"kELDashboardItemSettings", nil),
                   @"segueIdentifier": @"Settings"};
    
    [mItems addObject:[[ELMenuItem alloc] initWithDictionary:detailDict error:nil]];
    
    detailDict = @{@"name": NSLocalizedString(@"kELLogoutButton", nil),
                   @"segueIdentifier": @"Logout"};
    
    [mItems addObject:[[ELMenuItem alloc] initWithDictionary:detailDict error:nil]];
    
    return [mItems copy];
}

@end
