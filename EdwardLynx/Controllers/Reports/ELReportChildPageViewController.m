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
    // Detailed Answer Summary per category data
//    self.items = @[@{@"dataPoints": @[@{@"Question": @1,
//                                        @"Percentage": @0,
//                                        @"Percentage_1": @0.14},
//                                      @{@"Question": @2,
//                                        @"Percentage": @0.25,
//                                        @"Percentage_1": @0.5},
//                                      @{@"Question": @3,
//                                        @"Percentage": @0.8,
//                                        @"Percentage_1": @0.4}]}];

    // Radar Diagram
//    self.items = @[@[@{@"id": @176,
//                       @"name": @"Category 1",
//                       @"roles": @[@{@"id": @-1,
//                                     @"name": @"Others combined",
//                                     @"average": @0.65},
//                                   @{@"id": @9,
//                                     @"name": @"Candidates",
//                                     @"average": @0.15}]},
//                     @{@"id": @177,
//                       @"name": @"Category 2",
//                       @"roles": @[@{@"id": @-1,
//                                     @"name": @"Others combined",
//                                     @"average": @0.83333333333333},
//                                   @{@"id": @9,
//                                     @"name": @"Candidates",
//                                     @"average": @0.5}]},
//                     @{@"id": @178,
//                       @"name": @"Category 3",
//                       @"roles": @[@{@"id": @-1,
//                                     @"name": @"Others combined",
//                                     @"average": @0.66666666666667},
//                                   @{@"id": @9,
//                                     @"name": @"Candidates",
//                                     @"average": @0}]}]];
    
    self.items = @[@{@"id": @529,
                     @"categoryId": @177,
                     @"category": @"Category 2",
                     @"yesPercentage": @100,
                     @"noPercentage": @0},
                   @{@"id": @529,
                     @"categoryId": @178,
                     @"category": @"Category 3",
                     @"yesPercentage": @54,
                     @"noPercentage": @46}];

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
    // Detailed Answer Summary per category data
//    return [self.items[0][@"dataPoints"] count];
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELReportChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                       forIndexPath:indexPath];
    
    // Detailed Answer Summary per category data
//    [cell configure:@{@"title": @"",
//                      @"type": @(kELReportChartTypeBar),
//                      @"data": self.items[0][@"dataPoints"][indexPath.row]}
//        atIndexPath:indexPath];
    
    // Radar Diagram
//    [cell configure:@{@"title": @"",
//                      @"type": @(kELReportChartTypeRadar),
//                      @"data": self.items[indexPath.row]}
//        atIndexPath:indexPath];
    
    // Yes/No
    [cell configure:@{@"title": self.items[indexPath.row][@"category"],
                      @"type": @(kELReportChartTypePie),
                      @"data": self.items[indexPath.row]}
        atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 500;
}

@end
