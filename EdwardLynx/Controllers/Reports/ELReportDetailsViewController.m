//
//  ELReportDetailsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

@import Charts;

#import <PNChart/PNBarChart.h>

#import "ELReportDetailsViewController.h"
#import "ELAnswerOption.h"
#import "ELDetailViewManager.h"
#import "ELInstantFeedback.h"
#import "ELInviteUsersViewController.h"
#import "ELSurvey.h"

#pragma mark - Class Extension

@interface ELReportDetailsViewController ()

@property (nonatomic, strong) NSString *typeColorKey;
@property (nonatomic, strong) ELDetailViewManager *viewManager;
@property (nonatomic, strong) ELInstantFeedback *instantFeedback;
@property (nonatomic, strong) ELSurvey *survey;
@property (nonatomic, strong) HorizontalBarChartView *averageBarChart, *indexBarChart;

@end

@implementation ELReportDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.averageBarChart = [[HorizontalBarChartView alloc] initWithFrame:self.averageBarChartView.bounds];
    self.indexBarChart = [[HorizontalBarChartView alloc] initWithFrame:self.indexBarChartView.bounds];
    self.averageBarChart.noDataText = @"";
    self.indexBarChart.noDataText = @"";
    
    self.viewManager = [[ELDetailViewManager alloc] initWithDetailObject:self.selectedObject];
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
        controller.instantFeedback = self.selectedObject;
    }
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    if ([self.selectedObject isKindOfClass:[ELInstantFeedback class]]) {
        self.instantFeedback = (ELInstantFeedback *)self.selectedObject;
        
        self.title = [@"FEEDBACK REPORT" uppercaseString];
        self.typeColorKey = kELFeedbackColor;
        self.headerLabel.text = self.instantFeedback.question.text;
        self.dateLabel.text = self.instantFeedback.dateString;
        self.infoLabel.text = [NSString stringWithFormat:NSLocalizedString(@"kELReportInfoLabel", nil),
                               @(self.instantFeedback.participants.count),
                               @(self.instantFeedback.noOfParticipantsAnswered)];
        
        [self.indexHeightConstraint setConstant:0];
        [self.indexContainerView updateConstraints];
    } else {
        self.survey = (ELSurvey *)self.selectedObject;
        
        self.title = [self.survey.name uppercaseString];
        self.typeColorKey = kELLynxColor;
        
        [self.indexHeightConstraint setConstant:450];
        [self.indexContainerView updateConstraints];
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
    [self setupIndexBarChart:self.indexBarChart answers:[mAnswers copy]];
}

#pragma mark - Private Methods

- (BarChartDataSet *)chartDataSetWithTitle:(NSString *)title
                                     items:(NSArray *)items
                                  colorKey:(NSString *)colorKey {
    BarChartDataSet *dataSet;
    UIColor *color = [[RNThemeManager sharedManager] colorForKey:colorKey];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.minimumFractionDigits = 0;
    formatter.numberStyle = NSNumberFormatterPercentStyle;
    
    dataSet = [[BarChartDataSet alloc] initWithValues:items label:title];
    dataSet.colors = @[color];
    dataSet.valueFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    dataSet.valueFormatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:formatter];
    dataSet.valueTextColor = color;
    
    return dataSet;
}

- (HorizontalBarChartView *)configureBarChart:(HorizontalBarChartView *)barChart {
    ChartLimitLine *limitLine70, *limitLine100;
    UIFont *labelFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    
    barChart.drawBordersEnabled = NO;
    barChart.drawGridBackgroundEnabled = NO;
    barChart.descriptionText = @"";
    
    barChart.leftAxis.axisMaximum = 1.0f;
    barChart.leftAxis.axisMinimum = 0.0f;
    barChart.leftAxis.drawAxisLineEnabled = NO;
    barChart.leftAxis.drawGridLinesEnabled = NO;
    barChart.leftAxis.drawLabelsEnabled = NO;
    barChart.leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    limitLine70 = [[ChartLimitLine alloc] initWithLimit:0.7f label:@"70%"];
    limitLine70.labelPosition = ChartLimitLabelPositionLeftBottom;
    limitLine70.lineColor = [[RNThemeManager sharedManager] colorForKey:kELTextFieldBGColor];
    limitLine70.lineWidth = 0.5f;
    limitLine70.valueFont = labelFont;
    limitLine70.valueTextColor = [UIColor whiteColor];
    
    [barChart.leftAxis addLimitLine:limitLine70];
    
    limitLine100 = [[ChartLimitLine alloc] initWithLimit:1.0f label:@"100%"];
    limitLine100.labelPosition = ChartLimitLabelPositionLeftBottom;
    limitLine100.lineColor = [[RNThemeManager sharedManager] colorForKey:kELTextFieldBGColor];
    limitLine100.lineWidth = 0.5f;
    limitLine100.valueFont = labelFont;
    limitLine100.valueTextColor = [UIColor whiteColor];
    
    [barChart.leftAxis addLimitLine:limitLine100];
    
    barChart.legend.enabled = YES;
    barChart.legend.font = labelFont;
    barChart.legend.position = ChartLegendPositionBelowChartCenter;
    barChart.legend.textColor = [UIColor whiteColor];
    
    barChart.rightAxis.drawAxisLineEnabled = NO;
    barChart.rightAxis.drawGridLinesEnabled = NO;
    barChart.rightAxis.drawLabelsEnabled = NO;
    
    barChart.userInteractionEnabled = NO;
    
    barChart.xAxis.centerAxisLabelsEnabled = NO;
    barChart.xAxis.drawGridLinesEnabled = NO;
    barChart.xAxis.granularity = 1;
    barChart.xAxis.granularityEnabled = YES;
    barChart.xAxis.labelFont = labelFont;
    barChart.xAxis.labelPosition = XAxisLabelPositionBottom;
    barChart.xAxis.labelTextColor = [UIColor whiteColor];
    barChart.xAxis.wordWrapEnabled = YES;
    
    return barChart;
}

- (void)setupAverageBarChart:(HorizontalBarChartView *)barChart answers:(NSArray<ELAnswerOption *> *)answers {
    NSInteger count;
    NSMutableArray *mLabels = [[NSMutableArray alloc] init];
    NSMutableArray<BarChartDataEntry *> *mEntries = [[NSMutableArray alloc] init];
    
    count = [self.selectedObject isKindOfClass:[ELInstantFeedback class]] ? self.instantFeedback.participants.count : 42;  // TEMP
    
    for (int i = 0; i < answers.count; i++) {
//        double y = answers[i].count / count;
        double y = (double)arc4random() / UINT32_MAX;
        
        [mLabels addObject:answers[i].shortDescription];
        [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:y]];
    }
    
    barChart = [self configureBarChart:barChart];
    barChart.data = [[BarChartData alloc] initWithDataSet:[self chartDataSetWithTitle:@"Self"
                                                                                items:[mEntries copy]
                                                                             colorKey:self.typeColorKey]];
    barChart.legend.enabled = NO;
    barChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:[mLabels copy]];
    
    [self.averageIndicatorView stopAnimating];
    [barChart animateWithYAxisDuration:0.5];
}

- (void)setupIndexBarChart:(HorizontalBarChartView *)barChart answers:(NSArray<ELAnswerOption *> *)answers {
    NSInteger count;
    BarChartData *chartData;
    BarChartDataSet *chartDataSet1, *chartDataSet2;
    NSMutableArray *mLabels = [[NSMutableArray alloc] init];
    NSMutableArray<BarChartDataEntry *> *mEntries = [[NSMutableArray alloc] init];
    
    count = [self.selectedObject isKindOfClass:[ELInstantFeedback class]] ? self.instantFeedback.participants.count : 42;  // TEMP
    
    for (int i = 0; i < answers.count; i++) {
//        double y = answers[i].count / count;
        double y = (double)arc4random() / UINT32_MAX;
        
        [mLabels addObject:answers[i].shortDescription];
        [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:y]];
    }
    
    chartDataSet1 = [self chartDataSetWithTitle:@"Self"
                                          items:[mEntries copy]
                                       colorKey:self.typeColorKey];
    
    [mEntries removeAllObjects];
    
    // TODO Dummy data
    
    for (int i = 0; i < answers.count; i++) {
//        double y = answers[i].count / count;
        double y = (double)arc4random() / UINT32_MAX;
        
        [mLabels addObject:answers[i].shortDescription];
        [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:y]];
    }
    
    chartDataSet2 = [self chartDataSetWithTitle:@"Others Combined"
                                          items:[mEntries copy]
                                       colorKey:kELOrangeColor];
    
    chartData = [[BarChartData alloc] initWithDataSets:@[chartDataSet1, chartDataSet2]];
    chartData.barWidth = 0.45f;
    
    [chartData groupBarsFromX:0.0f groupSpace:0.06f barSpace:0.02f];
    
    barChart = [self configureBarChart:barChart];
    barChart.data = chartData;
    barChart.xAxis.centerAxisLabelsEnabled = YES;
    barChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:[mLabels copy]];
    
    [self.indexIndicatorView stopAnimating];
    [barChart animateWithYAxisDuration:0.5];
}

#pragma mark - Interface Builder Actions

- (IBAction)onShareBarButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"ShareReport" sender:self];
}

@end
