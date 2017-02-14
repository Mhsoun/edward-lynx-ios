//
//  ELListPopupViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELListPopupViewController.h"
#import "ELDataProvider.h"
#import "ELFilterSortItem.h"
#import "ELListTableViewCell.h"
#import "ELTableDataSource.h"

#pragma mark - Private Methods

static NSString * const kELCellIdentifier = @"ListCell";

#pragma mark - Class Extension

@interface ELListPopupViewController ()

@property (nonatomic) BOOL isFilter;
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
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:self.detailsDict[@"items"]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    
    self.tableView.rowHeight = 40;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.dataSource dataSetEmptyText:@"" description:@""];
    [self.tableView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    self.isFilter = [self.detailsDict[@"type"] isEqualToString:@"filter"];
    
    [self.titleLabel setText:[NSLocalizedString(self.isFilter ? @"kELFilterByLabel" : @"kELSortByLabel", nil) uppercaseString]];
    [self.confirmButton setTitle:NSLocalizedString(self.isFilter ? @"kELFilterLabel" : @"kELSortLabel", nil)
                        forState:UIControlStateNormal];
}

#pragma mark - Interface Builder Actions

- (IBAction)onCancelButtonClick:(id)sender {
    [self.controller dismissPopupViewControllerAnimated:YES completion:nil];
}

- (IBAction)onConfirmButtonClick:(id)sender {
    NSMutableArray *mItems = [[NSMutableArray alloc] init];
    NSMutableArray *mSelectedItems = [[NSMutableArray alloc] init];
    
    if (!self.controller.popupViewController) {
        return;
    }
    
    for (int i = 0; i < [self.provider numberOfRows]; i++) {
        ELListTableViewCell *cell;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
        
        cell = (ELListTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        [mItems addObject:cell.item];
        
        if (cell.item.selected) {
            [mSelectedItems addObject:cell.item];
        }
    }
    
    [self.controller dismissPopupViewControllerAnimated:YES completion:^{
        if (self.isFilter) {
            [self.delegate onFilterSelections:[mSelectedItems copy] allFilterItems:[mItems copy]];
        } else {
            [self.delegate onSortSelections:[mSelectedItems copy] allSortItems:[mItems copy]];
        }
    }];
}

@end
