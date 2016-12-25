//
//  ELSurveysViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveysViewController.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"SurveyCell";

#pragma mark - Class Extension

@interface ELSurveysViewController ()

@property (nonatomic, strong) NSIndexPath *prevIndexPath;
@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) ELDataProvider<NSString *> *provider;

@end

@implementation ELSurveysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.provider = [[ELDataProvider alloc] initWithDataArray:@[@"Dashboard", @"Profile", @"Surveys", @"Logout"]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    // Text Field
    UITextField *searchTextField = [self.searchBar valueForKey:@"_searchField"];
    UIFont *font = [UIFont fontWithName:@"Lato-Regular" size:searchTextField.font.pointSize];
    
    [searchTextField setFont:font];
    [searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [searchTextField setMinimumFontSize:12];
    
    // Cancel Button
    id barButtonAppearanceInSearchBar = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]];
    
    [barButtonAppearanceInSearchBar setTitle:@"Cancel"];
    [barButtonAppearanceInSearchBar setTitleTextAttributes:@{NSFontAttributeName: font,
                                                             NSForegroundColorAttributeName: [UIColor blackColor]}
                                                  forState:UIControlStateNormal];
}

@end
