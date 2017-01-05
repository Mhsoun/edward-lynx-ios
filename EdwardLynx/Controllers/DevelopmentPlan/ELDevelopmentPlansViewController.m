//
//  ELDevelopmentPlansViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDevelopmentPlansViewController.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"DevelopmentPlanCell";

#pragma mark - Class Extension

@interface ELDevelopmentPlansViewController ()

@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) ELDataProvider<ELDevelopmentPlan *> *provider;

@end

@implementation ELDevelopmentPlansViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    NSDictionary *testData = @{@"name": @"Test Development Plan",
                               @"timestamp": @"3 days ago",
                               @"status": @"unfinished"};
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:@[[[ELDevelopmentPlan alloc] initWithDictionary:testData error:nil],
                                                                [[ELDevelopmentPlan alloc] initWithDictionary:testData error:nil],
                                                                [[ELDevelopmentPlan alloc] initWithDictionary:testData error:nil]]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Search Bar
    [ELUtils styleSearchBar:self.searchBar];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // TODO Implementation
}

#pragma mark - Protocol Methods (UITableView)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO Handle selection
}

#pragma mark - Interface Builder Actions

- (IBAction)onTabButtonClick:(id)sender {
    NSArray *buttons = @[self.allTabButton,
                         self.unfinishedTabButton,
                         self.completedTabButton];
    
    for (UIButton *button in buttons) {
        [button setEnabled:![sender isEqual:button]];
    }
}

@end
