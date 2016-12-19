//
//  ELLeftMenuViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 19/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELLeftMenuViewController.h"

#pragma mark - Private Constants

static NSString * const kCellIdentifier = @"MenuItemCell";

#pragma mark - Class Extension

@interface ELLeftMenuViewController ()

@property (nonatomic, strong) NSIndexPath *prevIndexPath;
@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) ELDataProvider<NSString *> *provider;

@end

@implementation ELLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:@[@"Dashboard", @"Settings", @"Logout"]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kCellIdentifier];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    
    // UI additions
    [self layoutPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    self.tableView.backgroundColor = [[RNThemeManager sharedManager] colorForKey:kELVioletColor];
    self.tableView.separatorColor = [[RNThemeManager sharedManager] colorForKey:kELDarkVioletColor];
}

#pragma mark - Protocol Methods (UITableView)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *segueIdentifier = [self.provider objectAtIndexPath:indexPath];
    
    if ([segueIdentifier isEqualToString:@"Logout"]) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Logout"
                                                                            message:@"Logging out will require the app for your credentials next time."
                                                                     preferredStyle:UIAlertControllerStyleAlert];
        
        [controller addAction:[UIAlertAction actionWithTitle:@"Logout"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil]];
        [controller addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil]];
        
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

- (NSString *)segueIdForIndexPath:(NSIndexPath *)indexPath {
    return [self.provider objectAtIndexPath:indexPath];
}

- (NSIndexPath *)selectedIndexPath {
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

@end
