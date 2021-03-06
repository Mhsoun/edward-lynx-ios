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
#import "ELAverage.h"
#import "ELDetailViewManager.h"
#import "ELIndexOverCompetenciesData.h"
#import "ELInstantFeedback.h"
#import "ELInstantFeedbackRespondentsViewController.h"
#import "ELInviteUsersViewController.h"
#import "ELReportFreeTextTableViewCell.h"
#import "ELSurvey.h"

#pragma mark - Private Constants

static CGFloat const kELBarHeight = 40;
static NSString * const kELCellIdentifier = @"ItemCell";
static NSString * const kELFreeTextCellIdentifier = @"ReportFreeTextCell";
static NSString * const kELAddMoreSegueIdentifier = @"AddMore";
static NSString * const kELRespondentsIdentifier = @"Respondents";
static NSString * const kELShareSegueIdentifier = @"ShareReport";

#pragma mark - Class Extension

@interface ELReportDetailsViewController ()

@property (nonatomic) BOOL toDisplayData;
@property (nonatomic, strong) NSString *typeColorKey;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray<ELAnswerOption *> *freeTextItems;
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
    self.toDisplayData = YES;
    
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.estimatedRowHeight = 45;
    
    [self.tableView registerNib:[UINib nibWithNibName:kELFreeTextCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELFreeTextCellIdentifier];
    
    self.viewManager = [[ELDetailViewManager alloc] initWithDetailObject:self.selectedObject];
    self.viewManager.delegate = self;
    
    self.averageBarChart = [[HorizontalBarChartView alloc] init];
    self.indexBarChart = [[HorizontalBarChartView alloc] init];
    self.averageBarChart.noDataText = @"";
    self.indexBarChart.noDataText = @"";
    
    [self.averageChartView addSubview:self.averageBarChart];
    [self.indexChartView addSubview:self.indexBarChart];
    
    if (self.infoDict) {
        self.bgView.hidden = YES;
        
        [self setupReportsWithData:self.infoDict];
        
        return;
    }
    
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
    } else {
        ELInstantFeedbackRespondentsViewController *controller = (ELInstantFeedbackRespondentsViewController *)[segue destinationViewController];
        
        controller.isFreeText = self.instantFeedback.question.answer.type == kELAnswerTypeText;
        controller.items = controller.isFreeText ? self.freeTextItems : self.items;
    }
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.freeTextItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELReportFreeTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELFreeTextCellIdentifier
                                                                          forIndexPath:indexPath];
    
    cell.label.text = (NSString *)[self.freeTextItems[indexPath.row] value];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    BOOL isSurvey;
    UIImage *image;
    
    isSurvey = [self.selectedObject isKindOfClass:[ELSurvey class]];
    image = [FontAwesome imageWithIcon:fa_ellipsis_vertical
                             iconColor:[UIColor whiteColor]
                              iconSize:25];
    
    // Content
    if ([self.selectedObject isKindOfClass:[ELInstantFeedback class]]) {
        self.instantFeedback = (ELInstantFeedback *)self.selectedObject;
        
        self.title = [NSLocalizedString(@"kELReportTitleFeedback", nil) uppercaseString];
        self.typeColorKey = kELFeedbackColor;
        self.averageValuesLabel.text = self.instantFeedback.question.text;
        self.headerLabel.text = self.instantFeedback.question.text;
        self.anonymousLabel.text = self.instantFeedback.anonymous ? NSLocalizedString(@"kELFeedbackAnonymousLabel", nil) : @"";
        self.dateLabel.text = self.instantFeedback.dateString;
        self.infoLabel.text = Format(NSLocalizedString(@"kELReportInfoLabel", nil),
                                     @(self.instantFeedback.invited),
                                     @(self.instantFeedback.answered));
    } else {
        self.survey = (ELSurvey *)self.selectedObject;
        
        self.title = [self.survey.name uppercaseString];
        self.typeColorKey = kELLynxColor;
    }
    
    self.detailLabel.hidden = self.instantFeedback ? YES : NO;
    
    [self.respondentsButton setTitle:NSLocalizedString(@"kELReportRespondents", nil)
                            forState:UIControlStateNormal];
    
    [self.moreBarButton setEnabled:!isSurvey];
    [self.moreBarButton setImage:!isSurvey ? image : nil];
    [self.moreBarButton setTintColor:[UIColor whiteColor]];
}

#pragma mark - Protocol Methods (ELDetailViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [self.indicatorView stopAnimating];
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDetailsPageLoadError", nil)
                     completion:nil];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    [self setupReportsWithData:responseDict];
}

#pragma mark - Private Methods

- (BarChartDataSet *)chartDataSetWithTitle:(NSString *)title
                                     items:(NSArray *)items
                                  colorKey:(NSString *)colorKey {
    BarChartDataSet *dataSet;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.minimumFractionDigits = 0;
    formatter.numberStyle = NSNumberFormatterPercentStyle;
    formatter.percentSymbol = @"";
    
    dataSet = [[BarChartDataSet alloc] initWithValues:items label:title];
    dataSet.colors = @[ThemeColor(colorKey)];
    dataSet.highlightEnabled = NO;
    dataSet.valueFont = Font(@"Lato-Regular", 10.0f);
    dataSet.valueFormatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:formatter];
    dataSet.valueTextColor = ThemeColor(colorKey);
    
    return dataSet;
}

- (NSDictionary *)chartInfoFromData:(NSArray *)answers grouping:(BOOL)forGrouping {
    double y;
    NSInteger count;
    NSMutableArray *mColors = [[NSMutableArray alloc] init];
    NSMutableArray *mEntries = [[NSMutableArray alloc] init];
    NSMutableArray *mLabels = [[NSMutableArray alloc] init];
    
    
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
            NSMutableArray<ELAverageIndex *> *mRoles;
            ELAverageIndex *firstAverageIndex;
            NSMutableArray<BarChartDataEntry *> *mGroup = [[NSMutableArray alloc] init];
            NSMutableArray<BarChartDataEntry *> *mGroup2 = [[NSMutableArray alloc] init];
            
            mColors = [[NSMutableArray alloc] initWithCapacity:answers.count];
            
            for (int i = 0; i < answers.count; i++) {
                ELIndexOverCompetenciesData *indexData = answers[i];
                
                mRoles = [indexData.roles mutableCopy];
                
                [mLabels addObject:indexData.name];
                
                if (mRoles.count <= 1) {
                    NSString *color, *name;
                    
                    firstAverageIndex = mRoles[0];
                    
                    // NOTE Should be dynamic
                    name = [firstAverageIndex.name isEqualToString:@"Others combined"] ? @"Candidate" : @"Others combined";
                    color = [firstAverageIndex.name isEqualToString:@"Others combined"] ? @"selfColor" : @"otherColor";
                    
                    [mRoles addObject:[[ELAverageIndex alloc] initWithDictionary:@{@"id": @(-1),
                                                                                   @"name": name,
                                                                                   @"color": color,
                                                                                   @"average": @0}
                                                                           error:nil]];
                }
                
                for (int j = 0; j < mRoles.count; j++) {
                    ELAverageIndex *averageIndex = mRoles[j];
                    
                    y = averageIndex.value;
                    
                    [mColors addObject:averageIndex.color];
                    
                    switch (j) {
                        case 0:
                            [mGroup2 addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:y]];
                            
                            break;
                        case 1:
                            [mGroup addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:y]];
                            
                            break;
                        default:
                            break;
                    }
                }
            }
            
            [mEntries addObject:mGroup];
            [mEntries addObject:mGroup2];
        } else {
            for (int i = 0; i < answers.count; i++) {
                ELAverageIndex *averageIndex = answers[i];
                
                y = averageIndex.value;
                
                [mLabels addObject:averageIndex.name];
                [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:y]];
            }
        }
    }
    
    return @{@"colors": [mColors copy],
             @"entries": [mEntries copy],
             @"labels": [mLabels copy]};
}

- (HorizontalBarChartView *)configureHorizontalBarChart:(HorizontalBarChartView *)barChart {
    double axisMax, axisMin;
    ChartLimitLine *limitLine;
    UIFont *dataFont = Font(@"Lato-Regular", 12.0f);
    UIFont *labelFont = Font(@"Lato-Regular", 10.0f);
    
    axisMax = 1.0f, axisMin = 0.0f;
    
    barChart.chartDescription.enabled = NO;
    barChart.doubleTapToZoomEnabled = NO;
    barChart.drawBarShadowEnabled = NO;
    barChart.drawBordersEnabled = NO;
    barChart.drawGridBackgroundEnabled = NO;
    barChart.extraRightOffset = 30.0f;
    barChart.highlightPerDragEnabled = NO;
    barChart.highlightPerTapEnabled = NO;
    barChart.pinchZoomEnabled = NO;
    
    barChart.leftAxis.axisMaximum = axisMax;
    barChart.leftAxis.axisMinimum = axisMin;
    barChart.leftAxis.drawAxisLineEnabled = NO;
    barChart.leftAxis.drawGridLinesEnabled = NO;
    barChart.leftAxis.drawLabelsEnabled = NO;
    barChart.leftAxis.drawLimitLinesBehindDataEnabled = YES;
    barChart.leftAxis.drawTopYLabelEntryEnabled = YES;
    
    for (NSNumber *value in @[@(0), @(0.70f), @(1.0f)]) {
        limitLine = [[ChartLimitLine alloc] initWithLimit:[value doubleValue]];
        limitLine.labelPosition = ChartLimitLabelPositionLeftBottom;
        limitLine.lineColor = ThemeColor(kELTextFieldBGColor);
        limitLine.lineWidth = 0.5f;
        limitLine.xOffset = 0;
        
        [barChart.leftAxis addLimitLine:limitLine];
    }
    
    barChart.legend.enabled = YES;
    barChart.legend.font = labelFont;
    barChart.legend.position = ChartLegendPositionBelowChartLeft;
    barChart.legend.textColor = [UIColor whiteColor];
    barChart.legend.yEntrySpace = 0.0f;
    
    barChart.noDataFont = dataFont;
    barChart.noDataText = Format(NSLocalizedString(@"kELReportRestrictedData", nil), @(kELParticipantsMinimumCount));
    barChart.noDataTextColor = ThemeColor(kELOrangeColor);
    
    barChart.rightAxis.axisMaximum = axisMax;
    barChart.rightAxis.axisMinimum = axisMin;
    barChart.rightAxis.drawAxisLineEnabled = NO;
    barChart.rightAxis.drawGridLinesEnabled = NO;
    barChart.rightAxis.drawLabelsEnabled = YES;
    barChart.rightAxis.labelCount = 10;
    barChart.rightAxis.labelFont = labelFont;
    barChart.rightAxis.labelTextColor = [UIColor whiteColor];
    barChart.rightAxis.valueFormatter = [ChartDefaultAxisValueFormatter withBlock:^NSString * _Nonnull(double value, ChartAxisBase * _Nullable base) {
        int percentage = (int)ceil((value * 100));
        
        switch (percentage) {
            case 0:
            case 70:
            case 100:
                return Format(@"%@%%", @(percentage));
            default:
                return @"";
        }
    }];
    barChart.rightAxis.yOffset = 1;
    
    barChart.xAxis.centerAxisLabelsEnabled = NO;
    barChart.xAxis.drawGridLinesEnabled = NO;
    barChart.xAxis.drawLabelsEnabled = YES;
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
        chartDataSet = [self chartDataSetWithTitle:NSLocalizedString(@"kELReportInfoSelf", nil)
                                             items:infoDict[@"entries"]
                                          colorKey:self.typeColorKey];
        chartData = [[BarChartData alloc] initWithDataSet:chartDataSet];
        chartData.barWidth = 0.5f;
        
        barChart.data = chartData;
    }
}

- (void)setupIndexBarChart:(HorizontalBarChartView *)barChart answers:(NSArray *)answers {
    double barSpace,
           groupSpace,
           groupWidth;
    NSInteger count;
    BarChartData *chartData;
    BarChartDataSet *chartDataSet1, *chartDataSet2;
    NSDictionary *infoDict = [self chartInfoFromData:answers[1] grouping:YES];  // NOTE Should use the `colors` key
    NSArray *labels = infoDict[@"labels"];
    
    count = labels.count;
    barSpace = 0.0f, groupSpace = 0.15f;
    
    chartDataSet1 = [self chartDataSetWithTitle:NSLocalizedString(@"kELReportInfoCandidates", nil)
                                          items:infoDict[@"entries"][0]
                                       colorKey:self.typeColorKey];
    chartDataSet2 = [self chartDataSetWithTitle:NSLocalizedString(@"kELReportInfoOthers", nil)
                                          items:infoDict[@"entries"][1]
                                       colorKey:kELOtherColor];
    
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
}

- (void)setupReportsWithData:(NSDictionary *)dataDict {
    CGFloat defaultHeight, height;
    NSInteger answered;
    BOOL showTable = NO;
    BOOL isFeedback = [self.selectedObject isKindOfClass:[ELInstantFeedback class]] && self.instantFeedback;
    NSMutableArray *mAnswers = [[NSMutableArray alloc] init];
    NSMutableArray *mAverage = [[NSMutableArray alloc] init];
    NSMutableArray *mIndex = [[NSMutableArray alloc] init];
    
    answered = isFeedback ? self.instantFeedback.answered : self.survey.answered;
    defaultHeight = 150;
    
    self.toDisplayData = isFeedback && self.instantFeedback.anonymous ? answered >= kELParticipantsMinimumCount : answered > 0;
    
    if (isFeedback) {
        for (NSDictionary *dict in dataDict[@"frequencies"]) {
            [mAnswers addObject:[[ELAnswerOption alloc] initWithDictionary:dict error:nil]];
        }
    } else {
        for (NSDictionary *dict in dataDict[@"average"]) {
            [mAverage addObject:[[ELAverageIndex alloc] initWithDictionary:dict error:nil]];
        }
        
        for (NSDictionary *dict in dataDict[@"ioc"]) {
            [mIndex addObject:[[ELIndexOverCompetenciesData alloc] initWithDictionary:dict error:nil]];
        }
        
        [mAnswers addObject:[mAverage copy]];
        [mAnswers addObject:[mIndex copy]];
    }
    
    if (isFeedback) {
        if (self.instantFeedback.question.answer.type == kELAnswerTypeText) {
            self.freeTextItems = [mAnswers copy];
            
            self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            self.tableView.dataSource = self;
            self.tableView.delegate = self;
            
            self.feedbackDateLabel.text = self.instantFeedback.dateString;
            self.feedbackInfoLabel.text = Format(NSLocalizedString(@"kELReportInfoLabel", nil),
                                                 @(self.instantFeedback.invited),
                                                 @(self.instantFeedback.answered));
            
            [self.indicatorView stopAnimating];
            [self.tableContainerView setHidden:NO];
            
            showTable = YES;
        } else {
            self.items = [mAnswers copy];
        }
        
        // Buttons
        self.respondentsButton.hidden = [dataDict[@"totalAnswers"] intValue] == 0;
    }
    
    if (showTable) {
        return;
    }
    
    height = (kELBarHeight * mAnswers.count) + kELBarHeight;
    height += self.instantFeedback && self.instantFeedback.anonymous ? 20 : 0;
    
    [self.averageHeightConstraint setConstant:self.toDisplayData ? height + (kELBarHeight / 2) : defaultHeight];
    [self.averageContainerView layoutIfNeeded];
    [self.indexHeightConstraint setConstant:isFeedback ? 0 : (self.toDisplayData ? (height * 1.8) : defaultHeight)];
    [self.indexContainerView layoutIfNeeded];
    
    self.averageBarChart.frame = self.averageChartView.bounds;
    self.indexBarChart.frame = self.indexChartView.bounds;
    
    [self.indicatorView stopAnimating];
    [self.scrollView setHidden:NO];
    [self setupAverageBarChart:self.averageBarChart answers:[mAnswers copy]];
    
    if (!isFeedback && mIndex.count > 0) {
        [self.indexContainerView setHidden:NO];
        [self setupIndexBarChart:self.indexBarChart answers:[mAnswers copy]];
    }
}

#pragma mark - Interface Builder Actions

- (IBAction)onMoreBarButtonClick:(UIBarButtonItem *)sender {
    UIAlertController *controller;
    __weak typeof(self) weakSelf = self;
    
    if ([self.selectedObject isKindOfClass:[ELSurvey class]]) {
        return;
    }
    
    controller = ActionSheet(nil, nil);
    
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

- (IBAction)onRespondentsButtonClick:(id)sender {
    [self performSegueWithIdentifier:kELRespondentsIdentifier sender:self];
}

@end
