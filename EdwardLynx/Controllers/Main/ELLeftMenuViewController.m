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

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    CGFloat imageWidth = CGRectGetWidth(self.tableView.frame) / 1.5;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 40, imageWidth, 60)];
    
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"Logo2"];
    
    [self.tableView setBackgroundColor:ThemeColor(kELHeaderColor)];
    [self.tableView.tableHeaderView addSubview:imageView];
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *segueIdentifier = [(ELMenuItem *)[self.provider rowObjectAtIndexPath:indexPath] segueIdentifier];
    
    if ([segueIdentifier isEqualToString:@"Logout"]) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *controller = Alert(NSLocalizedString(@"kELLogoutButton", nil),
                                              NSLocalizedString(@"kELLogoutAlertMessage", nil));
        
        [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELLogoutButton", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
            // Remove auth header
            [UserDefaults removeObjectForKey:kELAuthInstanceUserDefaultsKey];
            
            [weakSelf presentViewController:StoryboardController(@"Authentication", nil)
                                   animated:YES
                                 completion:nil];
        }]];
        [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.tableView selectRowAtIndexPath:weakSelf.prevIndexPath
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

#pragma mark - Protocol Methods (SASlideMenu)

- (void)configureMenuButton:(UIButton *)menuButton {
    UIImage *image = [[UIImage imageNamed:@"Menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [menuButton setFrame:CGRectMake(0, 0, 25, 20)];
    [menuButton setImage:image forState:UIControlStateNormal];
    [menuButton setTintColor:[UIColor whiteColor]];
}

- (Boolean)disableContentViewControllerCachingForIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (Boolean)disablePanGestureForIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)prepareForSwitchToContentViewController:(UINavigationController *)content {
    ELTabPageViewController *controller;
    
    switch (self.selectedIndexPath.row) {
        case 2:
            controller = content.viewControllers[0];
            controller.type = kELListTypeSurveys;
            controller.tabs = @[@(kELListFilterAll),
                                @(kELListFilterInstantFeedback),
                                @(kELListFilterLynxMeasurement)];
            
            break;
        case 3:
            controller = content.viewControllers[0];
            controller.type = kELListTypeDevPlan;
            controller.tabs = @[@(kELListFilterAll),
                                @(kELListFilterInProgress),
                                @(kELListFilterCompleted)];
            
            break;
        default:
            break;
    }
    
    // Assign nav controller as root for Push Notifications
    [ApplicationDelegate assignRootNavController:content];
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
    
    detailDict = @{@"name": NSLocalizedString(@"kELMenuItemDashboard", nil),
                   @"segueIdentifier": @"Dashboard",
                   @"iconIdentifier": fa_bullseye};
    
    [mItems addObject:[[ELMenuItem alloc] initWithDictionary:detailDict error:nil]];
    
    detailDict = @{@"name": NSLocalizedString(@"kELMenuItemProfile", nil),
                   @"segueIdentifier": @"Profile",
                   @"iconIdentifier": fa_user_circle_o};
    
    [mItems addObject:[[ELMenuItem alloc] initWithDictionary:detailDict error:nil]];
    
    detailDict = @{@"name": NSLocalizedString(@"kELMenuItemSurveys", nil),
                   @"segueIdentifier": @"Survey",
                   @"iconIdentifier": fa_paper_plane};
    
    [mItems addObject:[[ELMenuItem alloc] initWithDictionary:detailDict error:nil]];
    
    detailDict = @{@"name": NSLocalizedString(@"kELMenuItemDevelopmentPlan", nil),
                   @"segueIdentifier": @"DevelopmentPlan",
                   @"iconIdentifier": fa_briefcase};
    
    [mItems addObject:[[ELMenuItem alloc] initWithDictionary:detailDict error:nil]];
    
    detailDict = @{@"name": NSLocalizedString(@"kELMenuItemSettings", nil),
                   @"segueIdentifier": @"Settings",
                   @"iconIdentifier": fa_gear};
    
    [mItems addObject:[[ELMenuItem alloc] initWithDictionary:detailDict error:nil]];
    
    detailDict = @{@"name": NSLocalizedString(@"kELLogoutButton", nil),
                   @"segueIdentifier": @"Logout",
                   @"iconIdentifier": fa_sign_out};
    
    [mItems addObject:[[ELMenuItem alloc] initWithDictionary:detailDict error:nil]];
    
    return [mItems copy];
}

@end
