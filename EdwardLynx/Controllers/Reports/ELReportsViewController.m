//
//  ELReportsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELReportsViewController.h"
#import "ELCreateInstantFeedbackViewController.h"
#import "ELListViewController.h"
#import "ELInstantFeedback.h"
#import "ELReportDetailsViewController.h"
#import "ELReportPageViewController.h"

#pragma mark - Private Constants

static NSString * const kELFeedbackReportSegueIdentifier = @"ReportDetailsFeedback";
static NSString * const kELListSegueIdentifier = @"ListContainer";
static NSString * const kELSurveyReportSegueIdentifier = @"ReportDetailsSurvey";
static NSString * const kELInstantFeedbackSegueIdentifier = @"InstantFeedbackDetails";

#pragma mark - Class Extension

@interface ELReportsViewController ()

@property (strong, nonatomic) __kindof ELModel *selectedObject;

@end

@implementation ELReportsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.navigationItem.title = [self.navigationItem.title uppercaseString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kELFeedbackReportSegueIdentifier]) {
        ELReportDetailsViewController *controller = (ELReportDetailsViewController *)[segue destinationViewController];
        
        controller.selectedObject = self.selectedObject;
    } else if ([segue.identifier isEqualToString:kELInstantFeedbackSegueIdentifier]) {
        ELCreateInstantFeedbackViewController *controller = (ELCreateInstantFeedbackViewController *)[segue destinationViewController];
        
        controller.instantFeedback = self.selectedObject;
    } else if ([segue.identifier isEqualToString:kELListSegueIdentifier]) {
        ELListViewController *controller = (ELListViewController *)[segue destinationViewController];
        
        controller.delegate = self;
        controller.listType = kELListTypeReports;
        controller.listFilter = [self.tabs[self.index] integerValue];
    } else if ([segue.identifier isEqualToString:kELSurveyReportSegueIdentifier]) {
        ELReportPageViewController *controller = (ELReportPageViewController *)[segue destinationViewController];

        controller.selectedObject = self.selectedObject;
    }
}

#pragma mark - Protocol Methods (ELListViewController)

- (void)onRowSelection:(__kindof ELModel *)object {
    NSString *identifier = [object isKindOfClass:[ELInstantFeedback class]] ? kELFeedbackReportSegueIdentifier :
                                                                              kELSurveyReportSegueIdentifier;
    
    self.selectedObject = object;
    
    [self performSegueWithIdentifier:identifier sender:self];
}

#pragma mark - Protocol Methods (XLPagerTabStrip)

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController {
    return [[ELUtils labelByListFilter:[self.tabs[self.index] integerValue]] uppercaseString];
}

@end
