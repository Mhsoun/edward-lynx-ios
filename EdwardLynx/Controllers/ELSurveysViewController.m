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
@property (nonatomic, strong) NSIndexPath *prevIndexPath;
@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) ELDataProvider<ELSurvey *> *provider;

@end

@implementation ELSurveysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    NSDictionary *testData = @{@"title": @"Test Survey",
                               @"timestamp": @"1 day ago",
                               @"status": @"unfinished",
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
    self.searchBar.tintColor = [[RNThemeManager sharedManager] colorForKey:kELVioletColor];
    
    // Text Field
    UITextField *searchTextField = [self.searchBar valueForKey:@"_searchField"];
    UIFont *font = [UIFont fontWithName:@"Lato-Regular" size:16];
    
    [searchTextField setFont:font];
    [searchTextField setTextColor:[UIColor whiteColor]];
    [searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [searchTextField setMinimumFontSize:12];
    [searchTextField setBounds:CGRectMake(0, 0, CGRectGetWidth(searchTextField.frame), 40)];
    
    // Cancel Button
    id barButtonAppearanceInSearchBar = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]];
    
    [barButtonAppearanceInSearchBar setTitle:@"Cancel"];
    [barButtonAppearanceInSearchBar setTitleTextAttributes:@{NSFontAttributeName: font,
                                                             NSForegroundColorAttributeName: [UIColor whiteColor]}
                                                  forState:UIControlStateNormal];
}

#pragma mark - Protocol Methods (UITableView)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedSurvey = [self.provider objectAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"SurveyDetails" sender:self];
}

#pragma mark - Interface Builder Actions

- (IBAction)onTabButtonClick:(id)sender {
    // TODO Move to view manager
    
    NSArray *buttons = @[self.allTabButton,
                         self.unfinishedTabButton,
                         self.completedTabButton];
    
    for (UIButton *button in buttons) {
        [button setEnabled:![sender isEqual:button]];
    }
}

@end
