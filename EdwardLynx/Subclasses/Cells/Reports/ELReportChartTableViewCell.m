//
//  ELReportChartTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

@import Charts;

#import "ELReportChartTableViewCell.h"
#import "ELAnswerSummary.h"
#import "ELAverage.h"
#import "ELBlindspot.h"
#import "ELRadarDiagram.h"
#import "ELQuestionRate.h"
#import "ELResponseRate.h"
#import "ELYesNoData.h"

#pragma mark - Class Extension

@interface ELReportChartTableViewCell ()

@property (nonatomic, strong) BarChartView *barChart;
@property (nonatomic, strong) HorizontalBarChartView *horizontalBarChart;
@property (nonatomic, strong) PieChartView *pieChart;
@property (nonatomic, strong) RadarChartView *radarChart;

@end

@implementation ELReportChartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.barChart removeFromSuperview];
    [self.horizontalBarChart removeFromSuperview];
    [self.pieChart removeFromSuperview];
    [self.radarChart removeFromSuperview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    CGRect frame;
    kELReportChartType type;
    NSDictionary *detailDict = (NSDictionary *)object;
    
    type = [detailDict[@"type"] integerValue];
    
    frame = self.bounds;
    frame.size.height = CGRectGetHeight(frame) - 55;
    frame.size.width = CGRectGetWidth(frame) - 20;
    
    switch (type) {
        case kELReportChartTypeBarCategory:
        case kELReportChartTypeBarResponseRate:
            if ([self hasClassViewAsSubview:[BarChartView class]]) {
                return;
            }
            
            self.barChart = [[BarChartView alloc] initWithFrame:frame];
            
            [self.chartContainerView addSubview:self.barChart];
            
            if (type == kELReportChartTypeBarCategory) {
                [self setupDetailedAnswerSummaryChartWithData:detailDict[@"data"]];
            } else {
                [self setupResponseRateWithData:detailDict];
            }
            
            break;
        case kELReportChartTypeHorizontalBarBlindspot:
        case kELReportChartTypeHorizontalBarBreakdown:
        case kELReportChartTypeHorizontalBarHighestLowest:
            if ([self hasClassViewAsSubview:[HorizontalBarChartView class]]) {
                return;
            }
            
            self.horizontalBarChart = [[HorizontalBarChartView alloc] initWithFrame:frame];
            
            [self.chartContainerView addSubview:self.horizontalBarChart];
            
            if (type == kELReportChartTypeHorizontalBarBlindspot) {
                [self setupBlindspotChartWithData:detailDict[@"data"]];
            } else if (type == kELReportChartTypeHorizontalBarBreakdown) {
                self.titleLabel.text = detailDict[@"data"][@"category"];
                self.detailLabel.text = @"";
                
                [self setupBreakdownByParticipantChartWithData:detailDict[@"data"]];
            } else {
                [self setupHighestLowestWithData:detailDict[@"data"] title:detailDict[@"title"]];
            }
            
            break;
        case kELReportChartTypePie:
            if ([self hasClassViewAsSubview:[PieChartView class]]) {
                return;
            }
            
            self.pieChart = [[PieChartView alloc] initWithFrame:frame];
            
            [self.chartContainerView addSubview:self.pieChart];
            [self setupYesOrNoChartWithData:detailDict[@"data"]];
            
            break;
        case kELReportChartTypeRadar:
            if ([self hasClassViewAsSubview:[RadarChartView class]]) {
                return;
            }
            
            self.radarChart = [[RadarChartView alloc] initWithFrame:frame];
            
            [self.chartContainerView addSubview:self.radarChart];
            [self setupRadarChartWithData:detailDict[@"data"]];
            
            break;
        default:
            break;
    }
}

#pragma mark - Private Methods

- (BarChartDataSet *)chartDataSetWithTitle:(NSString *)title
                                     items:(NSArray *)items
                                  colorKey:(NSString *)colorKey {
    BarChartDataSet *dataSet;
    UIColor *color = ThemeColor(colorKey);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.minimumFractionDigits = 0;
    formatter.numberStyle = NSNumberFormatterPercentStyle;
    
    dataSet = [[BarChartDataSet alloc] initWithValues:items label:title];
    dataSet.colors = @[color];
    dataSet.highlightEnabled = NO;
    dataSet.valueColors = @[color];
    dataSet.valueFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    dataSet.valueFormatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:formatter];
    
    return dataSet;
}

- (BarChartView *)configureBarChart:(BarChartView *)barChart {
    double axisMax, axisMin;
    UIFont *dataFont = [UIFont fontWithName:@"Lato-Regular" size:12];
    UIFont *labelFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    
    axisMax = 1.0f, axisMin = 0.0f;
    
    barChart.chartDescription.enabled = NO;
    barChart.doubleTapToZoomEnabled = NO;
    barChart.drawBarShadowEnabled = NO;
    barChart.drawBordersEnabled = NO;
    barChart.drawGridBackgroundEnabled = NO;
    barChart.extraTopOffset = 20.0f;
    barChart.highlightPerDragEnabled = NO;
    barChart.highlightPerTapEnabled = NO;
    barChart.pinchZoomEnabled = NO;
    
    barChart.leftAxis.axisMaximum = axisMax;
    barChart.leftAxis.axisMinimum = axisMin;
    barChart.leftAxis.drawAxisLineEnabled = NO;
    barChart.leftAxis.drawGridLinesEnabled = NO;
    barChart.leftAxis.drawLabelsEnabled = YES;
    barChart.leftAxis.drawLimitLinesBehindDataEnabled = YES;
    barChart.leftAxis.drawTopYLabelEntryEnabled = YES;
    barChart.leftAxis.labelCount = 5;
    barChart.leftAxis.labelFont = labelFont;
    barChart.leftAxis.labelTextColor = [UIColor whiteColor];
    
    barChart.noDataFont = dataFont;
    barChart.noDataText = [NSString stringWithFormat:NSLocalizedString(@"kELReportRestrictedData", nil),
                           @(kELParticipantsMinimumCount)];
    barChart.noDataTextColor = ThemeColor(kELOrangeColor);
    
    barChart.rightAxis.axisMaximum = axisMax;
    barChart.rightAxis.axisMinimum = axisMin;
    barChart.rightAxis.drawAxisLineEnabled = NO;
    barChart.rightAxis.drawGridLinesEnabled = NO;
    barChart.rightAxis.drawLabelsEnabled = NO;
    barChart.rightAxis.drawLimitLinesBehindDataEnabled = YES;
    
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

- (HorizontalBarChartView *)configureHorizontalBarChart:(HorizontalBarChartView *)barChart {
    double axisMax, axisMin;
    UIFont *dataFont = [UIFont fontWithName:@"Lato-Regular" size:12];
    UIFont *labelFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    
    axisMax = 1.0f, axisMin = 0.0f;
    
    barChart.chartDescription.enabled = NO;
    barChart.clipsToBounds = NO;
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
    barChart.leftAxis.drawGridLinesEnabled = YES;
    barChart.leftAxis.drawLabelsEnabled = NO;
    barChart.leftAxis.drawLimitLinesBehindDataEnabled = YES;
    barChart.leftAxis.drawTopYLabelEntryEnabled = YES;
    
    barChart.noDataFont = dataFont;
    barChart.noDataText = [NSString stringWithFormat:NSLocalizedString(@"kELReportRestrictedData", nil),
                           @(kELParticipantsMinimumCount)];
    barChart.noDataTextColor = ThemeColor(kELOrangeColor);
    
    barChart.rightAxis.axisMaximum = axisMax;
    barChart.rightAxis.axisMinimum = axisMin;
    barChart.rightAxis.drawAxisLineEnabled = NO;
    barChart.rightAxis.drawGridLinesEnabled = NO;
    barChart.rightAxis.drawLabelsEnabled = YES;
    barChart.rightAxis.drawLimitLinesBehindDataEnabled = YES;
    barChart.rightAxis.labelCount = 10;
    barChart.rightAxis.labelFont = labelFont;
    barChart.rightAxis.labelTextColor = [UIColor whiteColor];
    barChart.rightAxis.yOffset = 1.0f;
    
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

- (BOOL)hasClassViewAsSubview:(Class)class {
    for (UIView *subview in self.chartContainerView.subviews) {
        if ([subview isKindOfClass:class]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)setupBlindspotChartWithData:(NSDictionary *)data {
    BOOL isNumeric;
    NSMutableArray *mColors,
                   *mEntries,
                   *mXLabels,
                   *mYLabels;
    BarChartData *chartData;
    BarChartDataSet *chartDataSet;
    BarChartDataEntry *entry;
    UIFont *labelFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    ELBlindspot *blindspot = [[ELBlindspot alloc] initWithDictionary:data error:nil];
    
    // Content
    self.titleLabel.text = blindspot.category;
    self.detailLabel.text = blindspot.title;
    
    // Chart
    isNumeric = blindspot.answerType.isNumeric;
    mColors = [[NSMutableArray alloc] init];
    mEntries = [[NSMutableArray alloc] init];
    mXLabels = [[NSMutableArray alloc] init];
    mYLabels = [[NSMutableArray alloc] init];
    
    entry = [[BarChartDataEntry alloc] initWithX:(double)0 y:blindspot.selfPercentage];
    
    [mEntries addObject:entry];
    [mColors addObject:ThemeColor(kELLynxColor)];
    
    entry = [[BarChartDataEntry alloc] initWithX:(double)1 y:blindspot.othersPercentage];
    
    [mEntries addObject:entry];
    [mColors addObject:ThemeColor(kELOtherColor)];
    
    // NOTE Use supplied labels
//    [mYLabels addObject:@"Candidates"];
//    [mYLabels addObject:@"Others Combined"];
    
    // NOTE Localized
    [mYLabels addObject:NSLocalizedString(@"kELReportInfoCandidates", nil)];
    [mYLabels addObject:NSLocalizedString(@"kELReportInfoOthers", nil)];
    
    chartDataSet = [self chartDataSetWithTitle:@""
                                         items:[mEntries copy]
                                      colorKey:kELGreenColor];
    chartDataSet.colors = [mColors copy];
    chartDataSet.valueColors = [mColors copy];
    chartDataSet.valueFormatter = [ChartDefaultValueFormatter withBlock:^NSString * _Nonnull(double value, ChartDataEntry * _Nonnull entry, NSInteger i, ChartViewPortHandler * _Nullable handler) {
        int percentage = (int)floor((value * 100));
        
        return [NSString stringWithFormat:@"%@", @(percentage)];
    }];
    
    chartData = [[BarChartData alloc] initWithDataSet:chartDataSet];
    chartData.barWidth = 0.5f;
    
    self.horizontalBarChart = [self configureHorizontalBarChart:self.horizontalBarChart];
    self.horizontalBarChart.legend.enabled = NO;
    
    self.horizontalBarChart.leftAxis.drawGridLinesEnabled = NO;
    
    if (isNumeric) {
        for (NSNumber *value in @[@(0.7f), @(1.0f)]) {
            ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:[value doubleValue]];
            
            limitLine.labelPosition = ChartLimitLabelPositionLeftBottom;
            limitLine.lineColor = ThemeColor(kELTextFieldBGColor);
            limitLine.lineWidth = 0.5f;
            limitLine.xOffset = 0.0f;
            
            [self.horizontalBarChart.rightAxis addLimitLine:limitLine];
        }
    } else {
        [self.horizontalBarChart.rightAxis removeAllLimitLines];
        [mXLabels addObjectsFromArray:blindspot.answerType.optionKeys];
    }
    
    self.horizontalBarChart.rightAxis.axisMaximum = isNumeric ? 1.0f : mXLabels.count;
    self.horizontalBarChart.rightAxis.drawGridLinesEnabled = !isNumeric;
    self.horizontalBarChart.rightAxis.labelFont = labelFont;
    self.horizontalBarChart.rightAxis.valueFormatter = [ChartDefaultAxisValueFormatter withBlock:^NSString * _Nonnull(double value, ChartAxisBase * _Nullable base) {
        int percentage = (int)ceil((value * 100));
        
        if (isNumeric) {
            switch (percentage) {
                case 0:
                case 70:
                case 100:
                    return [NSString stringWithFormat:@"%@%%", @(percentage)];
                default:
                    return @"";
            }
        } else {
            int index = 0;
            
            if (value != 0) {
                index = (int)value;
                
                if (index == mXLabels.count) {
                    index--;
                }
            }
            
            return [mXLabels objectAtIndex:index];
        }
    }];
    
    if (blindspot.answerType.type == kELAnswerTypeAgreeementScale ||
        blindspot.answerType.type == kELAnswerTypeCustomScale ||
        blindspot.answerType.type == kELAnswerTypeInvertedAgreementScale ||
        blindspot.answerType.type == kELAnswerTypeStrongAgreeementScale) {
        labelFont = [UIFont fontWithName:@"Lato-Regular" size:8.5f];
        
        self.horizontalBarChart.rightAxis.labelFont = labelFont;
    }
    
    [self.horizontalBarChart.rightAxis setLabelCount:isNumeric ? 10 : mXLabels.count force:!isNumeric];
    
    self.horizontalBarChart.xAxis.labelCount = mYLabels.count;
    self.horizontalBarChart.xAxis.labelFont = labelFont;
    self.horizontalBarChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:mYLabels];
    
    self.horizontalBarChart.data = chartData;
}

- (void)setupBreakdownByParticipantChartWithData:(NSDictionary *)data {
    NSMutableArray *mColors,
                   *mEntries,
                   *mLabels;
    BarChartData *chartData;
    BarChartDataSet *chartDataSet;
    BarChartDataEntry *entry;
    NSArray *items = data[@"dataPoints"];
    
    mColors = [[NSMutableArray alloc] init];
    mEntries = [[NSMutableArray alloc] init];
    mLabels = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < items.count; i++) {
        ELDataPointBreakdown *dataPoint = [[ELDataPointBreakdown alloc] initWithDictionary:items[i] error:nil];
        
        //        entry = [[BarChartDataEntry alloc] initWithX:(double)(items.count - 1) - i y:dataPoint.percentage];
        entry = [[BarChartDataEntry alloc] initWithX:(double)i y:dataPoint.percentage];
        
        [mEntries addObject:entry];
        [mLabels addObject:dataPoint.title];
        [mColors addObject:ThemeColor(dataPoint.colorKey)];
    }
    
    self.horizontalBarChart = [self configureHorizontalBarChart:self.horizontalBarChart];
    self.horizontalBarChart.legend.enabled = NO;
    
    self.horizontalBarChart.leftAxis.drawGridLinesEnabled = NO;
    
    for (NSNumber *value in @[@(0.0f), @(0.7f), @(1.0f)]) {
        ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:[value doubleValue]];
        
        limitLine.labelPosition = ChartLimitLabelPositionLeftBottom;
        limitLine.lineColor = ThemeColor(kELTextFieldBGColor);
        limitLine.lineWidth = 0.5f;
        limitLine.xOffset = 0.0f;
        
        [self.horizontalBarChart.leftAxis addLimitLine:limitLine];
    }
    
    self.horizontalBarChart.rightAxis.valueFormatter = [ChartDefaultAxisValueFormatter withBlock:^NSString * _Nonnull(double value, ChartAxisBase * _Nullable base) {
        int percentage = (int)ceil((value * 100));
        
        switch (percentage) {
            case 0:
            case 70:
            case 100:
                return [NSString stringWithFormat:@"%@%%", @(percentage)];
            default:
                return @"";
        }
    }];
    
    self.horizontalBarChart.xAxis.labelCount = mLabels.count;
    self.horizontalBarChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:mLabels];
    
    chartDataSet = [self chartDataSetWithTitle:@""
                                         items:[mEntries copy]
                                      colorKey:kELGreenColor];
    chartDataSet.colors = [mColors copy];
    chartDataSet.valueColors = [mColors copy];
    chartDataSet.valueFormatter = [ChartDefaultValueFormatter withBlock:^NSString * _Nonnull(double value, ChartDataEntry * _Nonnull entry, NSInteger i, ChartViewPortHandler * _Nullable handler) {
        int percentage = (int)floor((value * 100));
        
        return [NSString stringWithFormat:@"%@", @(percentage)];
    }];
    
    chartData = [[BarChartData alloc] initWithDataSet:chartDataSet];
    chartData.barWidth = 0.5f;
    
    self.horizontalBarChart.data = chartData;
}

- (void)setupDetailedAnswerSummaryChartWithData:(NSDictionary *)data {
    NSMutableArray *mEntries;
    ELDataPointSummary *dataPoint;
    BarChartData *chartData;
    BarChartDataSet *chartDataSet;
    ChartLimitLine *limitLine;
    ELAnswerSummary *summary = [[ELAnswerSummary alloc] initWithDictionary:data error:nil];
    
    // Content
    self.titleLabel.text = summary.category;
    
    // Chart
    mEntries = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < summary.dataPoints.count; i++) {
        dataPoint = summary.dataPoints[i];
        
        [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:dataPoint.percentage]];
    }
    
    chartDataSet = [self chartDataSetWithTitle:@""
                                         items:[mEntries copy]
                                      colorKey:kELLynxColor];
    chartDataSet.valueFormatter = [ChartDefaultValueFormatter withBlock:^NSString * _Nonnull(double value, ChartDataEntry * _Nonnull entry, NSInteger i, ChartViewPortHandler * _Nullable handler) {
        int percentage = (int)floor((value * 100));
        
        return [NSString stringWithFormat:@"%@", @(percentage)];
    }];
    
    chartData = [[BarChartData alloc] initWithDataSet:chartDataSet];
    chartData.barWidth = 0.5f;
    
    self.barChart = [self configureBarChart:self.barChart];
    self.barChart.legend.enabled = NO;
    
    for (NSNumber *value in @[@(0.0f), @(0.25f), @(0.50f), @(0.75f), @(1.0f)]) {
        limitLine = [[ChartLimitLine alloc] initWithLimit:[value doubleValue]];
        limitLine.labelPosition = ChartLimitLabelPositionLeftBottom;
        limitLine.lineColor = ThemeColor(kELTextFieldBGColor);
        limitLine.lineWidth = 0.5f;
        limitLine.xOffset = 0.0f;
        
        [self.barChart.leftAxis addLimitLine:limitLine];
    }
    
    self.barChart.leftAxis.granularity = 0.25f;
    self.barChart.leftAxis.valueFormatter = [ChartDefaultAxisValueFormatter withBlock:^NSString * _Nonnull(double value, ChartAxisBase * _Nullable base) {
        int percentage = (int)floor((value * 100));
        
        return [NSString stringWithFormat:@"%@%%", @(percentage)];
    }];
    
    self.barChart.xAxis.labelCount = [[summary pointKeys] count];
    self.barChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:[summary pointKeys]];
    
    self.barChart.data = chartData;
}

- (void)setupHighestLowestWithData:(NSDictionary *)data title:(NSString *)title {
    BOOL isManager, isNumeric;
    NSMutableArray *mColors,
                   *mEntries,
                   *mXLabels,
                   *mYLabels;
    BarChartData *chartData;
    BarChartDataSet *chartDataSet;
    BarChartDataEntry *entry;
    UIFont *labelFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    ELQuestionRate *rate = [[ELQuestionRate alloc] initWithDictionary:data error:nil];
    
    // Content
    self.titleLabel.text = rate.category;
    self.detailLabel.text = rate.question;
    
    // Chart
    isManager = [title isEqualToString:@"Manager"];
    isNumeric = rate.answerType.isNumeric;
    mColors = [[NSMutableArray alloc] init];
    mEntries = [[NSMutableArray alloc] init];
    mXLabels = [[NSMutableArray alloc] init];
    mYLabels = [[NSMutableArray alloc] init];
    
    entry = [[BarChartDataEntry alloc] initWithX:(double)0 y:rate.candidates];
    
    [mEntries addObject:entry];
    [mColors addObject:ThemeColor(kELLynxColor)];
    
    entry = [[BarChartDataEntry alloc] initWithX:(double)1 y:rate.others];
    
    [mEntries addObject:entry];
    [mColors addObject:ThemeColor(isManager ? kELOrangeColor : kELOtherColor)];
    
    // NOTE Use supplied labels
//    [mYLabels addObject:@"Candidates"];
//    [mYLabels addObject:title];
    
    // NOTE Localized
    [mYLabels addObject:NSLocalizedString(@"kELReportInfoCandidates", nil)];
    [mYLabels addObject:isManager ? NSLocalizedString(@"kELReportInfoManager", nil) :
                                    NSLocalizedString(@"kELReportInfoOthers", nil)];
    
    chartDataSet = [self chartDataSetWithTitle:@""
                                         items:[mEntries copy]
                                      colorKey:kELGreenColor];
    chartDataSet.colors = [mColors copy];
    chartDataSet.valueColors = [mColors copy];
    chartDataSet.valueFormatter = [ChartDefaultValueFormatter withBlock:^NSString * _Nonnull(double value, ChartDataEntry * _Nonnull entry, NSInteger i, ChartViewPortHandler * _Nullable handler) {
        int percentage = (int)floor((value * 100));
        
        return [NSString stringWithFormat:@"%@", @(percentage)];
    }];
    
    chartData = [[BarChartData alloc] initWithDataSet:chartDataSet];
    chartData.barWidth = 0.5f;
    
    self.horizontalBarChart = [self configureHorizontalBarChart:self.horizontalBarChart];
    self.horizontalBarChart.legend.enabled = NO;
    
    self.horizontalBarChart.leftAxis.drawGridLinesEnabled = NO;
    
    if (isNumeric) {
        for (NSNumber *value in @[@(0.7f), @(1.0f)]) {
            ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:[value doubleValue]];
            
            limitLine.labelPosition = ChartLimitLabelPositionLeftBottom;
            limitLine.lineColor = ThemeColor(kELTextFieldBGColor);
            limitLine.lineWidth = 0.5f;
            limitLine.xOffset = 0.0f;
            
            [self.horizontalBarChart.rightAxis addLimitLine:limitLine];
        }
    } else {
        [self.horizontalBarChart.rightAxis removeAllLimitLines];
        [mXLabels addObjectsFromArray:rate.answerType.optionKeys];
    }
    
    self.horizontalBarChart.rightAxis.axisMaximum = isNumeric ? 1.0f : mXLabels.count;
    self.horizontalBarChart.rightAxis.drawGridLinesEnabled = !isNumeric;
    self.horizontalBarChart.rightAxis.labelFont = labelFont;
    
    self.horizontalBarChart.rightAxis.valueFormatter = [ChartDefaultAxisValueFormatter withBlock:^NSString * _Nonnull(double value, ChartAxisBase * _Nullable base) {
        int percentage = (int)ceil((value * 100));
        
        if (isNumeric) {
            switch (percentage) {
                case 0:
                case 70:
                case 100:
                    return [NSString stringWithFormat:@"%@%%", @(percentage)];
                default:
                    return @"";
            }
        } else {
            int index = 0;
            
            if (value != 0) {
                index = (int)value;
                
                if (index == mXLabels.count) {
                    index--;
                }
            }
            
            return [mXLabels objectAtIndex:index];
        }
    }];
    
    if (rate.answerType.type == kELAnswerTypeAgreeementScale ||
        rate.answerType.type == kELAnswerTypeCustomScale ||
        rate.answerType.type == kELAnswerTypeInvertedAgreementScale ||
        rate.answerType.type == kELAnswerTypeStrongAgreeementScale) {
        labelFont = [UIFont fontWithName:@"Lato-Regular" size:8.5f];

        self.horizontalBarChart.rightAxis.labelFont = labelFont;
    }
    
    [self.horizontalBarChart.rightAxis setLabelCount:isNumeric ? 10 : mXLabels.count force:!isNumeric];
    
    self.horizontalBarChart.xAxis.labelCount = mYLabels.count;
    self.horizontalBarChart.xAxis.labelFont = labelFont;
    self.horizontalBarChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:mYLabels];
    
    self.horizontalBarChart.data = chartData;
}

- (void)setupRadarChartWithData:(NSArray *)items {
    double axisMin;
    NSMutableArray *mDataSets,
                   *mEntries,
                   *mEntries2,
                   *mLabels;
    ELAverage *average;
    ELRadarDiagram *radarDiagram;
    RadarChartData *chartData;
    RadarChartDataSet *chartDataSet;
    RadarChartDataEntry *entry;
    UIFont *labelFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    
    axisMin = 0.0f;
    
    mDataSets = [[NSMutableArray alloc] init];
    mEntries = [[NSMutableArray alloc] init];
    mEntries2 = [[NSMutableArray alloc] init];
    mLabels = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < items.count; i++) {
        double value = 0;
        
        radarDiagram = [[ELRadarDiagram alloc] initWithDictionary:items[i] error:nil];
        average = radarDiagram.roles[0];
        entry = [[RadarChartDataEntry alloc] initWithValue:average.value];
        
        [mEntries2 addObject:entry];
        
        if (radarDiagram.roles.count > 1) {
            average = radarDiagram.roles[1];
            value = average.value;
        }
        
        entry = [[RadarChartDataEntry alloc] initWithValue:value];
     
        [mLabels addObject:radarDiagram.name];
        [mEntries addObject:entry];
    }
    
    for (int i = 0; i < 2; i++) {
        NSString *label = i == 0 ? NSLocalizedString(@"kELReportInfoCandidates", nil) :
                                   NSLocalizedString(@"kELReportInfoOthers", nil);
        
        chartDataSet = [[RadarChartDataSet alloc] initWithValues:i == 0 ? mEntries : mEntries2 label:label];
        chartDataSet.colors = @[ThemeColor(i == 0 ? kELLynxColor : kELOrangeColor)];
        chartDataSet.drawValuesEnabled = NO;
        chartDataSet.highlightEnabled = NO;
    
        [mDataSets addObject:chartDataSet];
    }
    
    chartData = [[RadarChartData alloc] initWithDataSets:[mDataSets copy]];
    
    self.radarChart.chartDescription.enabled = NO;
    self.radarChart.innerWebColor = ThemeColor(kELTextFieldBGColor);
    self.radarChart.rotationEnabled = NO;
    self.radarChart.webColor = ThemeColor(kELTextFieldBGColor);
    
    self.radarChart.legend.drawInside = YES;
    self.radarChart.legend.font = labelFont;
    self.radarChart.legend.orientation = ChartLegendOrientationHorizontal;
    self.radarChart.legend.position = ChartLegendPositionBelowChartCenter;
    self.radarChart.legend.textColor = [UIColor whiteColor];
    self.radarChart.legend.xOffset = 0.0f;
    self.radarChart.legend.yEntrySpace = 0.0f;
    self.radarChart.legend.yOffset = 0.0f;

    self.radarChart.noDataFont = labelFont;
    self.radarChart.noDataText = NSLocalizedString(@"kELReportNoData", nil);
    self.radarChart.noDataTextColor = ThemeColor(kELOrangeColor);

    self.radarChart.xAxis.axisMinimum = axisMin;
    self.radarChart.xAxis.axisMaximum = 0.6f;
    self.radarChart.xAxis.drawAxisLineEnabled = NO;
    self.radarChart.xAxis.drawGridLinesEnabled = NO;
    self.radarChart.xAxis.labelFont = labelFont;
    self.radarChart.xAxis.labelCount = mLabels.count;
    self.radarChart.xAxis.labelTextColor = [UIColor whiteColor];
    self.radarChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:mLabels];
    self.radarChart.xAxis.xOffset = 0.0f;
    self.radarChart.xAxis.yOffset = 0.0f;

    self.radarChart.yAxis.axisMinimum = axisMin;
    self.radarChart.yAxis.axisMaximum = 0.8f;
    self.radarChart.yAxis.drawAxisLineEnabled = NO;
    self.radarChart.yAxis.drawGridLinesEnabled = NO;
    self.radarChart.yAxis.labelCount = 5;
    self.radarChart.yAxis.labelFont = labelFont;
    self.radarChart.yAxis.labelTextColor = [UIColor whiteColor];
    self.radarChart.yAxis.valueFormatter = [ChartDefaultAxisValueFormatter withBlock:^NSString * _Nonnull(double value, ChartAxisBase * _Nullable axisBase) {
        int percentage = (int)floorf((value * 100));
        
        return [NSString stringWithFormat:@"%@", @(percentage)];
    }];
    self.radarChart.yAxis.xOffset = 0.0f;
    self.radarChart.yAxis.yOffset = 0.0f;
    
    self.radarChart.data = chartData;
}

- (void)setupResponseRateWithData:(NSDictionary *)data {
    NSMutableArray *mColors,
                   *mEntries,
                   *mLabels;
    ELDataPointBreakdown *dataPoint;
    BarChartData *chartData;
    BarChartDataSet *chartDataSet;
    ChartLimitLine *limitLine;
    ELResponseRate *responseRate = [[ELResponseRate alloc] initWithDictionary:data error:nil];
    
    mColors = [[NSMutableArray alloc] init];
    mEntries = [[NSMutableArray alloc] init];
    mLabels = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < responseRate.dataPoints.count; i++) {
        dataPoint = responseRate.dataPoints[i];
        
        [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:dataPoint.percentage]];
        [mLabels addObject:dataPoint.title];
        [mColors addObject:ThemeColor(dataPoint.colorKey)];
    }
    
    chartDataSet = [self chartDataSetWithTitle:@""
                                         items:[mEntries copy]
                                      colorKey:kELLynxColor];
    chartDataSet.colors = [mColors copy];
    chartDataSet.drawValuesEnabled = NO;
    chartDataSet.valueColors = [mColors copy];
    chartDataSet.valueFormatter = [ChartDefaultValueFormatter withBlock:^NSString * _Nonnull(double value, ChartDataEntry * _Nonnull entry, NSInteger i, ChartViewPortHandler * _Nullable handler) {
        return [NSString stringWithFormat:@"%@", @(value)];
    }];
    
    chartData = [[BarChartData alloc] initWithDataSet:chartDataSet];
    chartData.barWidth = 0.5f;
    
    self.barChart = [self configureBarChart:self.barChart];
    self.barChart.extraTopOffset = 0.0f;
    self.barChart.legend.enabled = NO;
    
    for (BarChartDataEntry *entry in [mEntries copy]) {
        limitLine = [[ChartLimitLine alloc] initWithLimit:entry.y];
        limitLine.lineColor = ThemeColor(kELTextFieldBGColor);
        limitLine.lineWidth = 0.5f;
        limitLine.xOffset = 0.0f;
    
        [self.barChart.leftAxis addLimitLine:limitLine];
    }
    
    self.barChart.leftAxis.axisMaximum = responseRate.maxValue;
    self.barChart.leftAxis.axisMinimum = 0.0f;
    self.barChart.leftAxis.drawAxisLineEnabled = NO;
    self.barChart.leftAxis.labelCount = responseRate.maxValue;
    self.barChart.leftAxis.valueFormatter = [ChartDefaultAxisValueFormatter withBlock:^NSString * _Nonnull(double value, ChartAxisBase * _Nullable base) {
        if ([responseRate.values containsObject:@(value)] || value == 0) {
            return [NSString stringWithFormat:@"%@", @(value)];
        }
        
        return @"";
    }];
    
    self.barChart.xAxis.labelCount = responseRate.dataPoints.count;
    self.barChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:[mLabels copy]];
    
    self.barChart.data = chartData;
}

- (void)setupYesOrNoChartWithData:(NSDictionary *)data {
    PieChartDataEntry *entry;
    PieChartDataSet *chartDataSet;
    UIFont *dataFont = [UIFont fontWithName:@"Lato-Regular" size:12];
    UIFont *labelFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    NSMutableArray *mEntries = [[NSMutableArray alloc] init];
    ELYesNoData *yesNoData = [[ELYesNoData alloc] initWithDictionary:data error:nil];
    
    // Content
    self.titleLabel.text = yesNoData.category;
    self.detailLabel.text = yesNoData.question;
    
    // Chart
    entry = [[PieChartDataEntry alloc] initWithValue:yesNoData.yesPercentage label:@"Yes"];
    
    [mEntries addObject:entry];
    
    entry = [[PieChartDataEntry alloc] initWithValue:yesNoData.noPercentage label:@"No"];
    
    [mEntries addObject:entry];
    
    if (yesNoData.naPercentage > 0) {
        entry = [[PieChartDataEntry alloc] initWithValue:yesNoData.noPercentage label:@"N/A"];
        
        [mEntries addObject:entry];
    }
    
    chartDataSet = [[PieChartDataSet alloc] initWithValues:[mEntries copy] label:@""];
    chartDataSet.colors = @[ThemeColor(kELDarkGrayColor), ThemeColor(kELVioletColor)];
    chartDataSet.valueFont = dataFont;
    
    self.pieChart.chartDescription.enabled = NO;
    self.pieChart.drawCenterTextEnabled = NO;
    self.pieChart.drawEntryLabelsEnabled = NO;
    self.pieChart.drawHoleEnabled = NO;
    
    self.pieChart._defaultValueFormatter = [ChartDefaultValueFormatter withBlock:^NSString * _Nonnull(double value, ChartDataEntry * _Nonnull entry, NSInteger i, ChartViewPortHandler * _Nullable handler) {
        return [NSString stringWithFormat:@"%@%%", @(value)];
    }];
    
    self.pieChart.legend.font = labelFont;
    self.pieChart.legend.textColor = [UIColor whiteColor];
    self.pieChart.legend.position = ChartLegendPositionRightOfChartCenter;
    
    self.pieChart.noDataFont = labelFont;
    self.pieChart.noDataText = NSLocalizedString(@"kELReportNoData", nil);
    self.pieChart.noDataTextColor = ThemeColor(kELOrangeColor);
    
    self.pieChart.data = [[PieChartData alloc] initWithDataSet:chartDataSet];
}

@end
