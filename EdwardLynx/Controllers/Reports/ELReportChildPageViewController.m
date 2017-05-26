//
//  ELReportChildPageViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELReportChildPageViewController.h"
#import "ELReportChartTableViewCell.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"ReportChartCell";

#pragma mark - Class Extension

@interface ELReportChildPageViewController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation ELReportChildPageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.items = @[@{@"dataPoints": @[@{@"Question": @1,
                                        @"Percentage": @0,
                                        @"Percentage_1": @0.14},
                                      @{@"Question": @2,
                                        @"Percentage": @0.25,
                                        @"Percentage_1": @0.5},
                                      @{@"Question": @3,
                                        @"Percentage": @0.8,
                                        @"Percentage_1": @0.4}]}];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items[0][@"dataPoints"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELReportChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                       forIndexPath:indexPath];
    
    [cell configure:@{@"title": @"",
                      @"type": @(kELReportChartTypeBar),
                      @"data": self.items[0][@"dataPoints"][indexPath.row]}
        atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

@end
