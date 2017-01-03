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
@property (nonatomic, strong) ELDataProvider<ELSurvey *> *provider;

@end

@implementation ELSurveysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    NSDictionary *testData = @{@"id": @1,
                               @"type": @0,
                               @"name": @"Test Survey",
                               @"lang": @"en",
                               @"description": @"The person that is being evaluated is: #to_evaluate_name.",
                               @"startDate": @"2017-01-01T20:40:04+0100",
                               @"endDate": @"2017-01-01T20:40:04+0100",
                               @"questions": @[@{@"detail": @"Describe yourself",
                                                 @"type": kELQuestionTypeText},
                                               @{@"detail": @"Describe your profession",
                                                 @"type": kELQuestionTypeText}]};
    
    self.selectedSurvey = nil;
    self.provider = [[ELDataProvider alloc] initWithDataArray:@[[[ELSurvey alloc] initWithDictionary:testData error:nil],
                                                                [[ELSurvey alloc] initWithDictionary:testData error:nil],
                                                                [[ELSurvey alloc] initWithDictionary:testData error:nil]]];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SurveyDetails"]) {
        ELSurveyDetailsViewController *controller = [segue destinationViewController];
        
        controller.survey = self.selectedSurvey;
    }
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
