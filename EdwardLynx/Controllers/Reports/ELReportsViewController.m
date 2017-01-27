//
//  ELReportsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELReportsViewController.h"

#pragma mark - Private Constants

static NSString * const kELReportSegueIdentifier = @"ReportDetails";

#pragma mark - Class Extension

@interface ELReportsViewController ()

@property (nonatomic, strong) NSArray *tabs;

@end

@implementation ELReportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.tabs = @[@(kELListFilterAll),
                  @(kELReportType360),
                  @(kELReportTypeInstant)];
    self.slideView.delegate = self;
    self.searchBar.delegate = self;
    
    // Slide view
    [ELUtils setupSlideView:self.slideView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kELReportSegueIdentifier]) {
        ELReportDetailsViewController *controller = (ELReportDetailsViewController *)[segue destinationViewController];
        
        controller.instantFeedback = self.selectedInstantFeedback;
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
    self.selectedInstantFeedback = (ELInstantFeedback *)object;
    
    [self performSegueWithIdentifier:kELReportSegueIdentifier sender:self];
}

#pragma mark - Protocol Methods (DYSlideView)

- (NSInteger)DY_numberOfViewControllersInSlideView {
    return self.tabs.count;
}

- (NSString *)DY_titleForViewControllerAtIndex:(NSInteger)index {
    return index == 0 ? @"ALL" : [[ELUtils labelByReportType:[self.tabs[index] integerValue]] uppercaseString];
}

- (UIViewController *)DY_viewControllerAtIndex:(NSInteger)index {
    ELListViewController *controller = [[UIStoryboard storyboardWithName:@"List" bundle:nil]
                                        instantiateInitialViewController];
    
    controller.delegate = self;
    controller.listType = kELListTypeReports;
    controller.listFilter = [self.tabs[index] integerValue];
    
    return controller;
}

@end
