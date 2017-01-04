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

@property (nonatomic, strong) ELSurvey *selectedSurvey;
@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) ELListViewManager *viewManager;
@property (nonatomic, strong) ELDataProvider<ELSurvey *> *provider;

@end

@implementation ELSurveysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.selectedSurvey = nil;
    self.viewManager = [[ELListViewManager alloc] init];
    self.viewManager.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELCellIdentifier];
    
    // Retrieve surveys
    [self.viewManager processRetrievalOfSurveys];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SurveyDetails"]) {
        ELSurveyDetailsViewController *controller = [segue destinationViewController];
        
        controller.survey = self.selectedSurvey;
    }
}

#pragma mark - Protocol Methods (ELAPIResponseDelegate)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    self.provider = [[ELDataProvider alloc] initWithDataArray:@[]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    
    [self.dataSource dataSetEmptyText:@"Failed to retrieve surveys"
                          description:@"Please try again later."];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    NSMutableArray *mData = [[NSMutableArray alloc] init];
    
    for (NSDictionary *surveyDict in responseDict[@"surveys"]) {
        [mData addObject:[[ELSurvey alloc] initWithDictionary:surveyDict error:nil]];
    }
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:[mData copy]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    
    [self.tableView reloadData];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    // Search Bar
    [ELUtils styleSearchBar:self.searchBar];
}

#pragma mark - Protocol Methods (UITableView)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedSurvey = [self.provider objectAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"SurveyDetails" sender:self];
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
