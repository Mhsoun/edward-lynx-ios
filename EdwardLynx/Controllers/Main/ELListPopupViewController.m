//
//  ELListPopupViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELListPopupViewController.h"
#import "ELDataProvider.h"
#import "ELListTableViewCell.h"
#import "ELTableDataSource.h"

#pragma mark - Private Methods

static NSString * const kELCellIdentifier = @"ListCell";

#pragma mark - Class Extension

@interface ELListPopupViewController ()

@property (nonatomic, strong) NSDictionary *detailsDict;
@property (nonatomic, strong) ELDataProvider *provider;
@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) __kindof ELBaseViewController *controller;

@end

@implementation ELListPopupViewController

#pragma mark - Lifecycle

- (instancetype)initWithPreviousController:(__kindof UIViewController *)controller
                                   details:(NSDictionary *)detailsDict {
    self = [super initWithNibName:@"ListPopupView" bundle:nil];
    
    if (!self) {
        return nil;
    }
    
    _controller = controller;
    _detailsDict = detailsDict;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.provider = [[ELDataProvider alloc] initWithDataArray:self.detailsDict[@"items"]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 45;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.dataSource dataSetEmptyText:@"" description:@""];
    [self.tableView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Protocol Methods (UITableView)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate onItemSelection:[self.provider rowObjectAtIndexPath:indexPath] index:indexPath.row];
    
    if (!self.controller.popupViewController) {
        return;
    }
    
    [self.controller dismissPopupViewControllerAnimated:YES completion:nil];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    self.titleLabel.text = self.detailsDict[@"title"];
}

@end
