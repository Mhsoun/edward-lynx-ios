//
//  ELSurveysViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveysViewController.h"
#import "ELAnswerInstantFeedbackViewController.h"
#import "ELInstantFeedback.h"
#import "ELListViewController.h"
#import "ELSurvey.h"
#import "ELSurveyCategoryPageViewController.h"
#import "ELSurveyRateOthersViewController.h"

#pragma mark - Private Constants

static NSString * const kELListSegueIdentifier = @"ListContainer";
static NSString * const kELInviteSegueIdentifier = @"Invite";
static NSString * const kELSurveySegueIdentifier = @"SurveyDetails";

#pragma mark - Class Extension

@interface ELSurveysViewController ()

@property (nonatomic, strong) ELSurvey *selectedSurvey;

@end

@implementation ELSurveysViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.title = [NSLocalizedString(@"kELDashboardActionInvite", nil) uppercaseString];
    self.bgView.hidden = self.tabs && self.tabs.count > 0;
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
    if ([segue.identifier isEqualToString:kELSurveySegueIdentifier]) {
        ELSurveyCategoryPageViewController *controller = (ELSurveyCategoryPageViewController *)[segue destinationViewController];
        
        controller.objectId = self.selectedSurvey.objectId;
        controller.key = self.selectedSurvey.key;
    } else if ([segue.identifier isEqualToString:kELListSegueIdentifier]) {
        ELListViewController *controller = (ELListViewController *)[segue destinationViewController];
        
        controller.delegate = self;
        controller.listType = kELListTypeSurveys;
        controller.listFilter = !self.tabs ? kELListFilterLynxMeasurement : [self.tabs[self.index] integerValue];
    } else if ([segue.identifier isEqualToString:kELInviteSegueIdentifier]) {
        ELSurveyRateOthersViewController *controller = (ELSurveyRateOthersViewController *)[segue destinationViewController];
        
        controller.objectId = self.selectedSurvey.objectId;
        controller.key = self.selectedSurvey.key;
    }
}

#pragma mark - Protocol Methods (ELListViewController)

- (void)onRowSelection:(__kindof ELModel *)object {
    ELInstantFeedback *instantFeedback;
    ELAnswerInstantFeedbackViewController *controller;
    
    if ([object isKindOfClass:[ELSurvey class]]) {
        self.selectedSurvey = (ELSurvey *)object;
        
        [self performSegueWithIdentifier:self.toInvite ? kELInviteSegueIdentifier : kELSurveySegueIdentifier
                                  sender:self];
        
        return;
    }
    
    instantFeedback = (ELInstantFeedback *)object;
    controller = StoryboardController(@"InstantFeedback", @"InstantFeedbackDetails");
    controller.objectId = instantFeedback.objectId;
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Protocol Methods (XLPagerTabStrip)

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController {
    return [[ELUtils labelByListFilter:[self.tabs[self.index] integerValue]] uppercaseString];
}

@end
