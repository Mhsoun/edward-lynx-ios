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

#pragma mark - Private Constants

static NSTimeInterval const kELAnimateInterval = 0.5;
static CGFloat const kELBarHeight = 40;

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
    self.averageBarChart = [[HorizontalBarChartView alloc] init];
    self.indexBarChart = [[HorizontalBarChartView alloc] init];
    self.averageBarChart.noDataText = @"";
    self.indexBarChart.noDataText = @"";
    
    self.viewManager = [[ELDetailViewManager alloc] initWithDetailObject:self.selectedObject];
    self.viewManager.delegate = self;
    
    [self.shareBarButton setTintColor:[[RNThemeManager sharedManager] colorForKey:kELOrangeColor]];
    [self.shareBarButton setImage:[FontAwesome imageWithIcon:fa_download
                                                   iconColor:[[RNThemeManager sharedManager] colorForKey:kELOrangeColor]
                                                    iconSize:25]];
    
    [self.averageChartView addSubview:self.averageBarChart];
    [self.indexChartView addSubview:self.indexBarChart];
    
    [self.indicatorView startAnimating];
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
                               @(self.instantFeedback.invited),
                               @(self.instantFeedback.answered)];
    } else {
        self.survey = (ELSurvey *)self.selectedObject;
        
        self.title = [self.survey.name uppercaseString];
        self.typeColorKey = kELLynxColor;
        self.dateLabel.text = self.survey.startDateString;
        self.infoLabel.text = [NSString stringWithFormat:NSLocalizedString(@"kELReportInfoLabel", nil),
                               @(self.survey.invited),
                               @(self.survey.answered)];
    }
}

#pragma mark - Protocol Methods (ELDetailViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [self.indicatorView stopAnimating];
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDetailsPageLoadError", nil)
                     completion:^{}];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    CGFloat height;
    BOOL isFeedback = [self.selectedObject isKindOfClass:[ELInstantFeedback class]] && self.instantFeedback;
    NSMutableArray *mAnswers = [[NSMutableArray alloc] init];
    
    if (isFeedback) {
        for (NSDictionary *answerDict in responseDict[@"frequencies"]) {
            [mAnswers addObject:[[ELAnswerOption alloc] initWithDictionary:answerDict error:nil]];
        }
    } else {
        [mAnswers addObject:responseDict[@"average"]];
        [mAnswers addObject:responseDict[@"ioc"]];
    }
    
    height = (kELBarHeight * mAnswers.count) + kELBarHeight;
    
    [self.averageHeightConstraint setConstant:height];
    [self.averageContainerView layoutIfNeeded];
    [self.indexHeightConstraint setConstant:isFeedback ? 0 : (height * 2)];
    [self.indexContainerView layoutIfNeeded];
    
    self.averageBarChart.frame = self.averageChartView.bounds;
    self.indexBarChart.frame = self.indexChartView.bounds;
    
    [self.indicatorView stopAnimating];
    [self.scrollView setHidden:NO];
    [self setupAverageBarChart:self.averageBarChart answers:[mAnswers copy]];
    
    if (!isFeedback) {
        [self setupIndexBarChart:self.indexBarChart answers:[mAnswers copy]];
    }
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
    dataSet.highlightEnabled = NO;
    dataSet.valueFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    dataSet.valueFormatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:formatter];
    dataSet.valueTextColor = color;
    
    return dataSet;
}

- (NSDictionary *)chartInfoFromData:(NSArray *)answers grouping:(BOOL)forGrouping {
    double y;
    NSInteger count;
    NSMutableArray *mLabels = [[NSMutableArray alloc] init];
    NSMutableArray *mEntries = [[NSMutableArray alloc] init];
    
    if ([self.selectedObject isKindOfClass:[ELInstantFeedback class]] && self.instantFeedback) {
        count = self.instantFeedback.invited;
        
        for (int i = 0; i < answers.count; i++) {
            ELAnswerOption *answer = answers[i];
            
            y = answer.count / count;
            
            [mLabels addObject:answer.shortDescription];
            [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:y]];
        }
    } else if (self.survey) {
        if (forGrouping) {
            NSMutableArray<BarChartDataEntry *> *mGroup = [[NSMutableArray alloc] init];
            NSMutableArray<BarChartDataEntry *> *mGroup2 = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < answers.count; i++) {
                NSDictionary *answerDict = answers[i];
                NSArray *roles = answerDict[@"roles"];
                
                [mLabels addObject:answerDict[@"name"]];
                
                for (int j = 0; j < roles.count; j++) {
                    NSDictionary *averageDict = roles[j];
                    
                    y = [averageDict[@"average"] doubleValue];
                    
                    if ([averageDict[@"name"] isEqualToString:@"Others combined"]) {
                        [mGroup2 addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:y]];
                    } else {
                        [mGroup addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:y]];
                    }
                }
            }
            
            [mEntries addObject:mGroup];
            [mEntries addObject:mGroup2];
        } else {
            count = self.survey.invited;
            
            for (int i = 0; i < answers.count; i++) {
                NSDictionary *answerDict = answers[i];
                
                y = [answerDict[@"average"] doubleValue];
                
                [mLabels addObject:answerDict[@"name"]];
                [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:y]];
            }
        }
    }
    
    return @{@"entries": [mEntries copy], @"labels": [mLabels copy]};
}

- (HorizontalBarChartView *)configureBarChart:(HorizontalBarChartView *)barChart {
    ChartLimitLine *limitLine70, *limitLine100;
    UIFont *labelFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    
    barChart.chartDescription.enabled = NO;
    barChart.doubleTapToZoomEnabled = NO;
    barChart.drawBarShadowEnabled = NO;
    barChart.drawBordersEnabled = NO;
    barChart.drawGridBackgroundEnabled = NO;
    barChart.highlightPerDragEnabled = NO;
    barChart.highlightPerTapEnabled = NO;
    barChart.maxVisibleCount = 15;
    barChart.pinchZoomEnabled = NO;
    
    barChart.leftAxis.axisMaximum = 1.1f;
    barChart.leftAxis.axisMinimum = 0.0f;
    barChart.leftAxis.drawAxisLineEnabled = NO;
    barChart.leftAxis.drawGridLinesEnabled = NO;
    barChart.leftAxis.drawLabelsEnabled = NO;
    barChart.leftAxis.drawTopYLabelEntryEnabled = YES;
    
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
    barChart.legend.position = ChartLegendPositionBelowChartLeft;
    barChart.legend.textColor = [UIColor whiteColor];
    barChart.legend.yEntrySpace = 0.0f;
    
    barChart.rightAxis.drawAxisLineEnabled = NO;
    barChart.rightAxis.drawGridLinesEnabled = NO;
    barChart.rightAxis.drawLabelsEnabled = NO;
    
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

- (void)setupAverageBarChart:(HorizontalBarChartView *)barChart answers:(NSArray *)answers {
    double barSpace, groupSpace;
    NSInteger count;
    BarChartData *chartData;
    BarChartDataSet *chartDataSet;
    NSDictionary *infoDict = [self chartInfoFromData:self.instantFeedback ? answers : answers[0] grouping:NO];
    NSArray *labels = infoDict[@"labels"];
    
    barSpace = 0.0f, groupSpace = 0.15f;
    count = labels.count;
    
    chartDataSet = [self chartDataSetWithTitle:NSLocalizedString(@"kELReportInfoSelf", nil)
                                         items:infoDict[@"entries"]
                                      colorKey:self.typeColorKey];
    
    chartData = [[BarChartData alloc] initWithDataSet:chartDataSet];
    
    barChart = [self configureBarChart:barChart];
    barChart.data = chartData;
    barChart.legend.enabled = NO;
    barChart.xAxis.labelCount = count;
    barChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:labels];
    
    [barChart groupBarsFromX:0 groupSpace:groupSpace barSpace:barSpace];
    [barChart animateWithYAxisDuration:kELAnimateInterval];
}

- (void)setupIndexBarChart:(HorizontalBarChartView *)barChart answers:(NSArray *)answers {
    double barSpace,
           groupSpace,
           groupWidth;
    NSInteger count;
    BarChartData *chartData;
    BarChartDataSet *chartDataSet1, *chartDataSet2;
    NSDictionary *infoDict = [self chartInfoFromData:answers[1] grouping:YES];
    NSArray *labels = infoDict[@"labels"];
    
    count = labels.count;
    barSpace = 0.0f, groupSpace = 0.15f;
    
    chartDataSet1 = [self chartDataSetWithTitle:NSLocalizedString(@"kELReportInfoSelf", nil)
                                          items:infoDict[@"entries"][0]
                                       colorKey:self.typeColorKey];
    chartDataSet2 = [self chartDataSetWithTitle:NSLocalizedString(@"kELReportInfoOthers", nil)
                                          items:infoDict[@"entries"][1]
                                       colorKey:kELOrangeColor];
    
    chartData = [[BarChartData alloc] initWithDataSets:@[chartDataSet1, chartDataSet2]];
    chartData.barWidth = 0.4f;
    
    barChart = [self configureBarChart:barChart];
    barChart.data = chartData;
    
    [barChart setVisibleXRangeMaximum:(double)count];
    [barChart setVisibleXRangeMinimum:(double)count];
    
    groupWidth = [chartData groupWidthWithGroupSpace:groupSpace barSpace:barSpace];
    
    barChart.xAxis.axisMaximum = groupWidth * (double)count;
    barChart.xAxis.axisMinimum = 0.0f;
    barChart.xAxis.centerAxisLabelsEnabled = YES;
    barChart.xAxis.labelCount = count;
    barChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:labels];
    
    [barChart groupBarsFromX:0 groupSpace:groupSpace barSpace:barSpace];
    [barChart animateWithYAxisDuration:kELAnimateInterval];
}

#pragma mark - Interface Builder Actions

- (IBAction)onShareBarButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"ShareReport" sender:self];
}

@end
