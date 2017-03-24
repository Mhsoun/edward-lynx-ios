//
//  ELSurveysViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveysViewController.h"
#import "ELListViewController.h"
#import "ELSurvey.h"
#import "ELSurveyDetailsViewController.h"

#pragma mark - Private Constants

static NSString * const kELListSegueIdentifier = @"ListContainer";
static NSString * const kELSurveySegueIdentifier = @"SurveyDetails";

#pragma mark - Class Extension

@interface ELSurveysViewController ()

@property (nonatomic, strong) NSArray *tabs;
@property (nonatomic, strong) ELSurvey *selectedSurvey;

@end

@implementation ELSurveysViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.searchBar.delegate = self;
    self.tabs = @[@(kELListFilterAll),
                  @(kELListFilterInProgress),
                  @(kELListFilterCompleted),
                  @(kELListFilterExpired)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kELSurveySegueIdentifier]) {
        ELSurveyDetailsViewController *controller = (ELSurveyDetailsViewController *)[segue destinationViewController];
        
        controller.survey = self.selectedSurvey;
    } else if ([segue.identifier isEqualToString:kELListSegueIdentifier]) {
        ELListViewController *controller = (ELListViewController *)[segue destinationViewController];
        
        controller.delegate = self;
        controller.listType = kELListTypeSurveys;
    }
}

#pragma mark - Protocol Methods (UISearchBar)

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // TODO Filtering implementation
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [[searchBar delegate] searchBar:searchBar textDidChange:@""];
    
    [searchBar setText:@""];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar endEditing:YES];
}

#pragma mark - Protocol Methods (ELListViewController)

- (void)onRowSelection:(__kindof ELModel *)object {
    self.selectedSurvey = (ELSurvey *)object;
    
    [self performSegueWithIdentifier:kELSurveySegueIdentifier sender:self];
}

@end
