//
//  ELDevelopmentPlansViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDevelopmentPlansViewController.h"
#import "ELDevelopmentPlan.h"
#import "ELDevelopmentPlanDetailsViewController.h"
#import "ELListViewController.h"

#pragma mark - Private Constants

static NSString * const kELListSegueIdentifier = @"ListContainer";
static NSString * const kELSDetailegueIdentifier = @"DevelopmentPlanDetail";

#pragma mark - Class Extension

@interface ELDevelopmentPlansViewController ()

@property (nonatomic, strong) ELDevelopmentPlan *selectedDevPlan;

@end

@implementation ELDevelopmentPlansViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kELSDetailegueIdentifier]) {
        ELDevelopmentPlanDetailsViewController *controller = (ELDevelopmentPlanDetailsViewController *)[segue destinationViewController];
        
        controller.devPlan = self.selectedDevPlan;
    } else if ([segue.identifier isEqualToString:kELListSegueIdentifier]) {
        ELListViewController *controller = (ELListViewController *)[segue destinationViewController];
        
        controller.delegate = self;
        controller.listType = kELListTypeDevPlan;
        controller.listFilter = [self.tabs[self.index] integerValue];
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
    self.selectedDevPlan = (ELDevelopmentPlan *)object;
    
    [self performSegueWithIdentifier:kELSDetailegueIdentifier sender:self];
}

#pragma mark - Protocol Methods (XLPagerTabStrip)

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController {
    return [[ELUtils labelByListFilter:[self.tabs[self.index] integerValue]] uppercaseString];
}

@end
