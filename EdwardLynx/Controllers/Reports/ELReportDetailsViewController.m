//
//  ELReportDetailsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

@import Charts;

#import "ELReportDetailsViewController.h"
#import "ELAnswerOption.h"
#import "ELDetailViewManager.h"
#import "ELInstantFeedback.h"
#import "ELInviteUsersViewController.h"
#import "ELSurvey.h"

#pragma mark - Private Constants

static NSTimeInterval const kELAnimateInterval = 0.5;
static CGFloat const kELBarHeight = 40;
static NSString * const kELAddMoreSegueIdentifier = @"AddMore";
static NSString * const kELShareSegueIdentifier = @"ShareReport";

#pragma mark - Class Extension

@interface ELReportDetailsViewController ()

@property (nonatomic) BOOL toDisplayData;
@property (nonatomic, strong) NSString *typeColorKey;
@property (nonatomic, strong) ELDetailViewManager *viewManager;
@property (nonatomic, strong) ELInstantFeedback *instantFeedback;
@property (nonatomic, strong) ELSurvey *survey;
@property (nonatomic, strong) BarChartView *categoryBarChart;
@property (nonatomic, strong) HorizontalBarChartView *averageBarChart, *indexBarChart;

@end

@implementation ELReportDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    BOOL isSurvey;
    UIImage *image;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isSurvey = [self.selectedObject isKindOfClass:[ELSurvey class]];
    image = [FontAwesome imageWithIcon:fa_ellipsis_vertical
                             iconColor:[UIColor whiteColor]
                              iconSize:25];
    
    // Initialization
    self.toDisplayData = YES;
    self.averageBarChart = [[HorizontalBarChartView alloc] init];
    self.indexBarChart = [[HorizontalBarChartView alloc] init];
    self.categoryBarChart = [[BarChartView alloc] init];
    self.averageBarChart.noDataText = @"";
    self.indexBarChart.noDataText = @"";
    
    self.viewManager = [[ELDetailViewManager alloc] initWithDetailObject:self.selectedObject];
    self.viewManager.delegate = self;
    
    [self.moreBarButton setEnabled:!isSurvey];
    [self.moreBarButton setImage:!isSurvey ? image : nil];
    [self.moreBarButton setTintColor:[UIColor whiteColor]];
    
    [self.averageChartView addSubview:self.averageBarChart];
    [self.indexChartView addSubview:self.indexBarChart];
    
    [self.indicatorView startAnimating];
    [self.viewManager processRetrievalOfReportDetails];
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
    ELInviteUsersViewController *controller = (ELInviteUsersViewController *)[segue destinationViewController];
    
    if ([segue.identifier isEqualToString:kELAddMoreSegueIdentifier]) {
        controller.inviteType = kELInviteUsersInstantFeedback;
        controller.instantFeedback = self.selectedObject;
        
    } else if ([segue.identifier isEqualToString:kELShareSegueIdentifier]) {
        ELInviteUsersViewController *controller = (ELInviteUsersViewController *)[segue destinationViewController];
        
        controller.inviteType = kELInviteUsersReports;
        controller.instantFeedback = self.selectedObject;
    }
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    if ([self.selectedObject isKindOfClass:[ELInstantFeedback class]]) {
        self.instantFeedback = (ELInstantFeedback *)self.selectedObject;
        
        self.title = [NSLocalizedString(@"kELReportTitleFeedback", nil) uppercaseString];
        self.typeColorKey = kELFeedbackColor;
        self.headerLabel.text = self.instantFeedback.question.text;
        self.anonymousLabel.text = self.instantFeedback.anonymous ? NSLocalizedString(@"kELFeedbackAnonymousLabel", nil) : @"";
        self.dateLabel.text = self.instantFeedback.dateString;
        self.infoLabel.text = [NSString stringWithFormat:NSLocalizedString(@"kELReportInfoLabel", nil),
                               @(self.instantFeedback.invited),
                               @(self.instantFeedback.answered)];
    } else {
        self.survey = (ELSurvey *)self.selectedObject;
        
        self.title = [self.survey.name uppercaseString];
        self.typeColorKey = kELLynxColor;
        self.dateLabel.text = self.survey.endDateString;
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
                     completion:nil];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    CGFloat height;
    NSInteger answered;
    BOOL isFeedback = [self.selectedObject isKindOfClass:[ELInstantFeedback class]] && self.instantFeedback;
    NSMutableArray *mAnswers = [[NSMutableArray alloc] init];
    
    answered = self.instantFeedback ? self.instantFeedback.answered : self.survey.answered;
    self.toDisplayData = self.instantFeedback && self.instantFeedback.anonymous ? answered >= kELParticipantsMinimumCount : answered > 0;
    
    if (isFeedback) {
        for (NSDictionary *answerDict in responseDict[@"frequencies"]) {
            [mAnswers addObject:[[ELAnswerOption alloc] initWithDictionary:answerDict error:nil]];
        }
    } else {
        [mAnswers addObject:responseDict[@"average"]];
        [mAnswers addObject:responseDict[@"ioc"]];
    }
    
    height = (kELBarHeight * mAnswers.count) + kELBarHeight;
    height += self.instantFeedback && self.instantFeedback.anonymous ? 20 : 0;
    
    [self.averageHeightConstraint setConstant:height + (kELBarHeight / 2)];
    [self.averageContainerView layoutIfNeeded];
    [self.indexHeightConstraint setConstant:isFeedback ? 0 : (height * 1.8)];
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
            
            y = (double)answer.count / count;
            
            [mLabels addObject:answer.shortDescription ? answer.shortDescription : (NSString *)answer.value];
            [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:y]];
        }
    } else if (self.survey) {
        if (forGrouping) {
            NSMutableArray<BarChartDataEntry *> *mGroup = [[NSMutableArray alloc] init];
            NSMutableArray<BarChartDataEntry *> *mGroup2 = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < answers.count; i++) {
                NSString *name;
                NSDictionary *firstAverageDict;
                NSDictionary *answerDict = answers[i];
                NSMutableArray *mRoles = [answerDict[@"roles"] mutableCopy];
                
                [mLabels addObject:answerDict[@"name"]];
                
                if (mRoles.count <= 1) {
                    firstAverageDict = mRoles[0];
                    name = [firstAverageDict[@"name"] isEqualToString:@"Others combined"] ? @"Candidate" : @"Others combined";
                    
                    [mRoles addObject:@{@"id": @(-1),
                                        @"average": @0,
                                        @"name": name}];
                }
                
                for (int j = 0; j < 2; j++) {
                    NSDictionary *averageDict = mRoles[j];
                    
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

- (BarChartView *)configureBarChart:(BarChartView *)barChart {
    double axisMax, axisMin;
    UIFont *dataFont = [UIFont fontWithName:@"Lato-Regular" size:12];
    UIFont *labelFont = [UIFont fontWithName:@"Lato-Regular" size:10];

    axisMax = 1.1f, axisMin = 0.0f;
    
    barChart.chartDescription.enabled = NO;
    barChart.doubleTapToZoomEnabled = NO;
    barChart.drawBarShadowEnabled = NO;
    barChart.drawBordersEnabled = NO;
    barChart.drawGridBackgroundEnabled = NO;
    barChart.highlightPerDragEnabled = NO;
    barChart.highlightPerTapEnabled = NO;
    barChart.maxVisibleCount = 10;
    barChart.pinchZoomEnabled = NO;

    barChart.leftAxis.axisMaximum = 1.1f;
    barChart.leftAxis.axisMinimum = 0.0f;
    barChart.leftAxis.drawAxisLineEnabled = NO;
    barChart.leftAxis.drawGridLinesEnabled = NO;
    barChart.leftAxis.drawLabelsEnabled = YES;
    barChart.leftAxis.drawTopYLabelEntryEnabled = YES;
    barChart.leftAxis.labelCount = 5;
    barChart.leftAxis.labelFont = labelFont;
    barChart.leftAxis.labelTextColor = [UIColor whiteColor];
    barChart.leftAxis.valueFormatter = [ChartDefaultAxisValueFormatter withBlock:^NSString * _Nonnull(double value, ChartAxisBase * _Nullable base) {
        int percentage = (int)ceil((value * 100));
        
        switch (percentage) {
            case 0:
            case 25:
            case 50:
            case 75:
            case 100:
                return [NSString stringWithFormat:@"%@%%", @(percentage)];
            default:
                return @"";
        }
    }];

    for (NSNumber *value in @[@(0), @(0.25f), @(0.50f), @(0.75f), @(1.0f)]) {
        ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:[value doubleValue]];
        
        limitLine.labelPosition = ChartLimitLabelPositionLeftBottom;
        limitLine.lineColor = [[RNThemeManager sharedManager] colorForKey:kELTextFieldBGColor];
        limitLine.lineWidth = 0.5f;
        limitLine.xOffset = 0;
        
        [barChart.leftAxis addLimitLine:limitLine];
    }
//
//    barChart.legend.enabled = YES;
//    barChart.legend.font = labelFont;
//    barChart.legend.position = ChartLegendPositionBelowChartLeft;
//    barChart.legend.textColor = [UIColor whiteColor];
//    barChart.legend.yEntrySpace = 0.0f;
    
    barChart.noDataFont = dataFont;
    barChart.noDataText = [NSString stringWithFormat:NSLocalizedString(@"kELReportRestrictedData", nil), @(kELParticipantsMinimumCount)];
    barChart.noDataTextColor = [[RNThemeManager sharedManager] colorForKey:kELOrangeColor];

    barChart.rightAxis.axisMaximum = 1.1f;
    barChart.rightAxis.axisMinimum = 0.0f;
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
    barChart.xAxis.labelWidth = 100;
    barChart.xAxis.wordWrapEnabled = YES;
    
    return barChart;
}

- (HorizontalBarChartView *)configureHorizontalBarChart:(HorizontalBarChartView *)barChart {
    double axisMax, axisMin;
    ChartLimitLine *limitLine70, *limitLine100;
    UIFont *dataFont = [UIFont fontWithName:@"Lato-Regular" size:12];
    UIFont *labelFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    
    axisMax = 1.1f, axisMin = 0.0f;
    
    barChart.chartDescription.enabled = NO;
    barChart.doubleTapToZoomEnabled = NO;
    barChart.drawBarShadowEnabled = NO;
    barChart.drawBordersEnabled = NO;
    barChart.drawGridBackgroundEnabled = NO;
    barChart.highlightPerDragEnabled = NO;
    barChart.highlightPerTapEnabled = NO;
    barChart.maxVisibleCount = 10;
    barChart.pinchZoomEnabled = NO;
    
    barChart.leftAxis.axisMaximum = axisMax;
    barChart.leftAxis.axisMinimum = axisMin;
    barChart.leftAxis.drawAxisLineEnabled = NO;
    barChart.leftAxis.drawGridLinesEnabled = NO;
    barChart.leftAxis.drawLabelsEnabled = NO;
    barChart.leftAxis.drawTopYLabelEntryEnabled = YES;
    
    limitLine70 = [[ChartLimitLine alloc] initWithLimit:0.7f];
    limitLine70.labelPosition = ChartLimitLabelPositionLeftBottom;
    limitLine70.lineColor = [[RNThemeManager sharedManager] colorForKey:kELTextFieldBGColor];
    limitLine70.lineWidth = 0.5f;
    
    [barChart.leftAxis addLimitLine:limitLine70];
    
    limitLine100 = [[ChartLimitLine alloc] initWithLimit:1.0f];
    limitLine100.labelPosition = ChartLimitLabelPositionLeftBottom;
    limitLine100.lineColor = [[RNThemeManager sharedManager] colorForKey:kELTextFieldBGColor];
    limitLine100.lineWidth = 0.5f;
    
    [barChart.leftAxis addLimitLine:limitLine100];
    
    barChart.legend.enabled = YES;
    barChart.legend.font = labelFont;
    barChart.legend.position = ChartLegendPositionBelowChartLeft;
    barChart.legend.textColor = [UIColor whiteColor];
    barChart.legend.yEntrySpace = 0.0f;
    
    barChart.noDataFont = dataFont;
    barChart.noDataText = [NSString stringWithFormat:NSLocalizedString(@"kELReportRestrictedData", nil), @(kELParticipantsMinimumCount)];
    barChart.noDataTextColor = [[RNThemeManager sharedManager] colorForKey:kELOrangeColor];
    
    barChart.rightAxis.axisMaximum = axisMax;
    barChart.rightAxis.axisMinimum = axisMin;
    barChart.rightAxis.drawAxisLineEnabled = NO;
    barChart.rightAxis.drawGridLinesEnabled = NO;
    barChart.rightAxis.drawLabelsEnabled = YES;
    barChart.rightAxis.yOffset = 1;
    barChart.rightAxis.labelCount = 10;
    barChart.rightAxis.labelFont = labelFont;
    barChart.rightAxis.labelPosition = YAxisLabelPositionOutsideChart;
    barChart.rightAxis.labelTextColor = [UIColor whiteColor];
    barChart.rightAxis.valueFormatter = [ChartDefaultAxisValueFormatter withBlock:^NSString * _Nonnull(double value, ChartAxisBase * _Nullable base) {
        int percentage = (int)ceil((value * 100));
        
        if (percentage == 70) {
            return @"70%";
        } else if (percentage == 100) {
            return @"100%";
        } else {
            return @"";
        }
    }];
    
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

- (void)setupAverageBarChart:(HorizontalBarChartView *)barChart answers:(NSArray *)answers {
    BarChartData *chartData;
    BarChartDataSet *chartDataSet;
    NSDictionary *infoDict = [self chartInfoFromData:self.instantFeedback ? answers : answers[0] grouping:NO];
    NSArray *labels = infoDict[@"labels"];
    
    barChart = [self configureHorizontalBarChart:barChart];
    barChart.legend.enabled = NO;
    barChart.xAxis.labelCount = labels.count;
    barChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:labels];
    
    if (self.toDisplayData) {
        double barSpace = 0.0f, groupSpace = 0.15f;
        
        chartDataSet = [self chartDataSetWithTitle:NSLocalizedString(@"kELReportInfoSelf", nil)
                                             items:infoDict[@"entries"]
                                          colorKey:self.typeColorKey];
        chartData = [[BarChartData alloc] initWithDataSet:chartDataSet];
        chartData.barWidth = 0.5f;
        
        barChart.data = chartData;
        
        [barChart groupBarsFromX:0 groupSpace:groupSpace barSpace:barSpace];
    }
    
    [barChart animateWithYAxisDuration:kELAnimateInterval];
}

- (void)setupCategoryBarChart:(BarChartView *)barChart answers:(NSArray *)answers {
    NSMutableArray *mEntries, *mLabels;
    BarChartData *chartData;
    BarChartDataSet *chartDataSet;

    mEntries = [[NSMutableArray alloc] init];
    mLabels = [[NSMutableArray alloc] init];
    
    // Dummy data
    for (int i = 0; i < 5; i++) {
        [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:0.5]];
        [mLabels addObject:[NSString stringWithFormat:@"%@", @(0.5f)]];
    }
    
    barChart = [self configureBarChart:barChart];
    barChart.legend.enabled = NO;
    barChart.xAxis.labelCount = mLabels.count;
    barChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:mLabels];
    
    if (self.toDisplayData) {
        double barSpace = 0.0f, groupSpace = 0.15f;
        
        chartDataSet = [self chartDataSetWithTitle:NSLocalizedString(@"kELReportInfoSelf", nil)
                                             items:[mEntries copy]
                                          colorKey:self.typeColorKey];
        chartData = [[BarChartData alloc] initWithDataSet:chartDataSet];
        chartData.barWidth = 0.5f;
        
        barChart.data = chartData;
        
        [barChart groupBarsFromX:0 groupSpace:groupSpace barSpace:barSpace];
    }
    
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
    
    chartDataSet1 = [self chartDataSetWithTitle:NSLocalizedString(@"kELReportInfoCandidates", nil)
                                          items:infoDict[@"entries"][0]
                                       colorKey:self.typeColorKey];
    chartDataSet2 = [self chartDataSetWithTitle:NSLocalizedString(@"kELReportInfoOthers", nil)
                                          items:infoDict[@"entries"][1]
                                       colorKey:kELOrangeColor];
    
    chartData = [[BarChartData alloc] initWithDataSets:@[chartDataSet1, chartDataSet2]];
    chartData.barWidth = 0.4f;
    
    barChart = [self configureHorizontalBarChart:barChart];
    
    if (self.toDisplayData) {
        barChart.data = chartData;
    }
    
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

- (IBAction)onMoreBarButtonClick:(UIBarButtonItem *)sender {
    UIAlertController *controller;
    __weak typeof(self) weakSelf = self;
    
    if ([self.selectedObject isKindOfClass:[ELSurvey class]]) {
        return;
    }
    
    controller = [UIAlertController alertControllerWithTitle:nil
                                                     message:nil
                                              preferredStyle:UIAlertControllerStyleActionSheet];
    
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELReportMoreDropdownShare", nil)
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     [weakSelf performSegueWithIdentifier:kELShareSegueIdentifier sender:self];
                                                 }]];
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELReportMoreDropdownAddMore", nil)
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     [weakSelf performSegueWithIdentifier:kELAddMoreSegueIdentifier sender:self];
                                                 }]];
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        controller.modalPresentationStyle = UIModalPresentationPopover;
        controller.popoverPresentationController.barButtonItem = sender;
    }
    
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}

@end
