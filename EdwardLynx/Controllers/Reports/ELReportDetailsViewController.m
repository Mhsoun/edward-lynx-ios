//
//  ELReportDetailsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <PNChart/PNBarChart.h>

#import "ELReportDetailsViewController.h"
#import "ELAnswerOption.h"
#import "ELDetailViewManager.h"
#import "ELInstantFeedback.h"
#import "ELInviteUsersViewController.h"

#pragma mark - Class Extension

@interface ELReportDetailsViewController ()

@property (nonatomic, strong) ELDetailViewManager *viewManager;
@property (nonatomic, strong) PNBarChart *averageBarChart, *indexBarChart;

@end

@implementation ELReportDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.title = [self.instantFeedback.question.text uppercaseString];
    
    // TEMP Values
    self.dateLabel.text = @"January 3, 2015";
    self.infoLabel.text = [NSString stringWithFormat:NSLocalizedString(@"kELReportInfoLabel", nil), @31, @31];
    
    self.averageBarChart = [[PNBarChart alloc] initWithFrame:self.averageBarChartView.bounds];
    self.averageBarChart.backgroundColor = [UIColor clearColor];
    self.averageBarChart.barBackgroundColor = [UIColor clearColor];
    
    self.indexBarChart = [[PNBarChart alloc] initWithFrame:self.indexBarChartView.bounds];
    self.indexBarChart.backgroundColor = [UIColor clearColor];
    self.indexBarChart.barBackgroundColor = [UIColor clearColor];

//    self.averageBarChart.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
    
    self.viewManager = [[ELDetailViewManager alloc] initWithDetailObject:self.instantFeedback];
    self.viewManager.delegate = self;
    
    [self.shareBarButton setTintColor:[[RNThemeManager sharedManager] colorForKey:kELOrangeColor]];
    [self.shareBarButton setImage:[FontAwesome imageWithIcon:fa_download
                                                   iconColor:[[RNThemeManager sharedManager] colorForKey:kELOrangeColor]
                                                    iconSize:25]];
    
    [self.averageBarChartView addSubview:self.averageBarChart];
    [self.indexBarChartView addSubview:self.indexBarChart];
    
    [self.viewManager processRetrievalOfReportDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShareReport"]) {
        ELInviteUsersViewController *controller = (ELInviteUsersViewController *)[segue destinationViewController];
        
        controller.inviteType = kELInviteUsersReports;
        controller.instantFeedback = self.instantFeedback;
    }
}

#pragma mark - Protocol Methods (ELDetailViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDetailsPageLoadError", nil)
                     completion:^{}];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    NSMutableArray<ELAnswerOption *> *mAnswers = [[NSMutableArray alloc] init];
    
    for (NSDictionary *answerDict in responseDict[@"frequencies"]) {
        [mAnswers addObject:[[ELAnswerOption alloc] initWithDictionary:answerDict error:nil]];
    }
    
    [self setupAverageBarChart:self.averageBarChart answers:[mAnswers copy]];
    [self setupIndexBarChar:self.indexBarChart answers:[mAnswers copy]];
    [self.averageBarChart strokeChart];
    [self.indexBarChart strokeChart];
}

#pragma mark - Private Methods

- (void)setupAverageBarChart:(PNBarChart *)barChart answers:(NSArray<ELAnswerOption *> *)answers {
//    NSMutableArray *mColors = [[NSMutableArray alloc] init];
    NSMutableArray *mLabels = [[NSMutableArray alloc] init];
    NSMutableArray *mValues = [[NSMutableArray alloc] init];
    
    barChart.barRadius = 0;
    barChart.barWidth = 20;
    barChart.chartMarginBottom = 0;
    barChart.chartMarginTop = 0;
    barChart.isGradientShow = NO;
    barChart.isShowNumbers = YES;
    barChart.labelFont = [UIFont fontWithName:@"Lato-Regular" size:8];
    barChart.labelMarginTop = 0;
    barChart.labelTextColor = [UIColor whiteColor];
    barChart.yChartLabelWidth = 0;
    
    for (ELAnswerOption *option in answers) {
        [mLabels addObject:option.shortDescription];
        [mValues addObject:@(option.count)];
    }
    
    barChart.xLabels = [mLabels copy];
    barChart.yValues = [mValues copy];
}

- (void)setupIndexBarChar:(PNBarChart *)barChart answers:(NSArray<ELAnswerOption *> *)answers {
    //    NSMutableArray *mColors = [[NSMutableArray alloc] init];
    NSMutableArray *mLabels = [[NSMutableArray alloc] init];
    NSMutableArray *mValues = [[NSMutableArray alloc] init];
    
    barChart.barRadius = 0;
    barChart.barWidth = 20;
    barChart.chartMarginBottom = 0;
    barChart.chartMarginTop = 0;
    barChart.isGradientShow = NO;
    barChart.isShowNumbers = YES;
    barChart.labelFont = [UIFont fontWithName:@"Lato-Regular" size:8];
    barChart.labelMarginTop = 0;
    barChart.labelTextColor = [UIColor whiteColor];
    barChart.xLabelSkip = 2;
    barChart.yChartLabelWidth = 0;
    
    for (ELAnswerOption *option in answers) {
        [mLabels addObject:option.shortDescription];
        [mValues addObject:@(option.count)];
    }
    
    barChart.xLabels = [mLabels copy];
    barChart.yValues = [mValues copy];
}

#pragma mark - Interface Builder Actions

- (IBAction)onShareBarButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"ShareReport" sender:self];
}

@end
