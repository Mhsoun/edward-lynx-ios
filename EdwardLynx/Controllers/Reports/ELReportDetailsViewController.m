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

#pragma mark - Class Extension

@interface ELReportDetailsViewController ()

@property (nonatomic, strong) ELDetailViewManager *viewManager;
@property (nonatomic, strong) HorizontalBarChartView *averageBarChart, *indexBarChart;

@end

@implementation ELReportDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.title = [self.instantFeedback.question.text uppercaseString];
    self.dateLabel.text = self.instantFeedback.dateString;
    self.infoLabel.text = [NSString stringWithFormat:NSLocalizedString(@"kELReportInfoLabel", nil),
                           @(self.instantFeedback.participants.count),
                           @(self.instantFeedback.noOfParticipantsAnswered)];
    
    self.averageBarChart = [[HorizontalBarChartView alloc] initWithFrame:self.averageBarChartView.bounds];
    self.indexBarChart = [[HorizontalBarChartView alloc] initWithFrame:self.indexBarChartView.bounds];
    
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
    [self setupIndexBarChart:self.indexBarChart answers:[mAnswers copy]];
}

#pragma mark - Private Methods

- (BarChartDataSet *)chartDataSetWithTitle:(NSString *)title
                                     items:(NSArray *)items
                                  colorKey:(NSString *)colorKey {
    BarChartDataSet *dataSet;
    
    dataSet = [[BarChartDataSet alloc] initWithValues:items label:title];
    dataSet.colors = @[[[RNThemeManager sharedManager] colorForKey:colorKey]];
    dataSet.valueFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    dataSet.valueTextColor = [UIColor whiteColor];
    
    return dataSet;
}

- (HorizontalBarChartView *)configureBarChart:(HorizontalBarChartView *)barChart {
    ChartLimitLine *limitLine70, *limitLine100;
    UIFont *labelFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    
    barChart.drawBordersEnabled = NO;
    barChart.drawGridBackgroundEnabled = NO;
    barChart.descriptionText = @"";
    
    barChart.leftAxis.drawAxisLineEnabled = NO;
    barChart.leftAxis.drawGridLinesEnabled = NO;
    barChart.leftAxis.drawLabelsEnabled = NO;
    barChart.leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    limitLine70 = [[ChartLimitLine alloc] initWithLimit:70.0 label:@"70%"];
    limitLine70.labelPosition = ChartLimitLabelPositionRightBottom;
    limitLine70.lineColor = [[RNThemeManager sharedManager] colorForKey:kELTextFieldBGColor];
    limitLine70.valueFont = labelFont;
    limitLine70.valueTextColor = [UIColor whiteColor];
    
    [barChart.leftAxis addLimitLine:limitLine70];
    
    limitLine100 = [[ChartLimitLine alloc] initWithLimit:100.0 label:@"100%"];
    limitLine100.labelPosition = ChartLimitLabelPositionRightBottom;
    limitLine100.lineColor = [[RNThemeManager sharedManager] colorForKey:kELTextFieldBGColor];
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
    barChart.xAxis.labelWidth = 100;
    barChart.xAxis.wordWrapEnabled = YES;
        
    return barChart;
}

- (void)setupAverageBarChart:(HorizontalBarChartView *)barChart answers:(NSArray<ELAnswerOption *> *)answers {
    NSMutableArray *mLabels = [[NSMutableArray alloc] init];
    NSMutableArray<BarChartDataEntry *> *mEntries = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < answers.count; i++) {
        if (answers[i].value < 0) {
            answers[i].value = 0;
        }
        
        [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:answers[i].value]];
        [mLabels addObject:answers[i].shortDescription];
    }
    
    barChart = [self configureBarChart:barChart];
    barChart.data = [[BarChartData alloc] initWithDataSet:[self chartDataSetWithTitle:@"Self"
                                                                                items:[mEntries copy]
                                                                             colorKey:kELGreenColor]];
    barChart.legend.enabled = NO;
    barChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:[mLabels copy]];
    
    [barChart animateWithYAxisDuration:0.5];
}

- (void)setupIndexBarChart:(HorizontalBarChartView *)barChart answers:(NSArray<ELAnswerOption *> *)answers {
    BarChartData *chartData;
    BarChartDataSet *chartDataSet1, *chartDataSet2;
    NSMutableArray *mLabels = [[NSMutableArray alloc] init];
    NSMutableArray<BarChartDataEntry *> *mEntries = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < answers.count; i++) {
        if (answers[i].value < 0) {
            answers[i].value = 0;
        }
        
        [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:answers[i].value]];
        [mLabels addObject:answers[i].shortDescription];
    }
    
    chartDataSet1 = [self chartDataSetWithTitle:@"Self"
                                          items:[mEntries copy]
                                       colorKey:kELOrangeColor];
    
    [mEntries removeAllObjects];
    
    // TODO Dummy data
    
    for (int i = 0; i < answers.count; i++) {
        if (answers[i].value < 0) {
            answers[i].value = 0;
        }
        
        [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:50.1f]];
        [mLabels addObject:answers[i].shortDescription];
    }
    
    chartDataSet2 = [self chartDataSetWithTitle:@"Others Combined"
                                          items:[mEntries copy]
                                       colorKey:kELGreenColor];
    
    chartData = [[BarChartData alloc] initWithDataSets:@[chartDataSet1, chartDataSet2]];
    chartData.barWidth = 0.45f;
    
    [chartData groupBarsFromX:0.0f groupSpace:0.06f barSpace:0.02f];
    
    barChart = [self configureBarChart:barChart];
    barChart.data = chartData;
    barChart.xAxis.centerAxisLabelsEnabled = YES;
    barChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:[mLabels copy]];
    
    [barChart animateWithYAxisDuration:0.5];
}

#pragma mark - Interface Builder Actions

- (IBAction)onShareBarButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"ShareReport" sender:self];
}

@end
