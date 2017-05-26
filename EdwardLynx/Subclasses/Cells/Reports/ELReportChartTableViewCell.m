//
//  ELReportChartTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

@import Charts;

#import "ELReportChartTableViewCell.h"

@interface ELReportChartTableViewCell ()

@property (nonatomic, strong) BarChartView *barChart;
@property (nonatomic, strong) HorizontalBarChartView *horizontalBarChart;
@property (nonatomic, strong) RadarChartView *radarChart;

@end

@implementation ELReportChartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    kELReportChartType type;
    NSDictionary *detailDict = (NSDictionary *)object;
    
    self.titleLabel.text = detailDict[@"title"];
    type = [detailDict[@"type"] integerValue];
    
    switch (type) {
        case kELReportChartTypeBar:
            self.barChart = [[BarChartView alloc] init];
            self.barChart.frame = self.chartContainerView.bounds;
            
            [self.chartContainerView addSubview:self.barChart];
            [self setupPerCategoryChart];
            
            break;
        case kELReportChartTypeRadar:
            self.radarChart = [[RadarChartView alloc] init];
            self.radarChart.frame = self.chartContainerView.bounds;
            
            [self.chartContainerView addSubview:self.radarChart];
            [self setupRadarChart];
            
            break;
        case kELReportChartTypeHorizontalBar:
            self.horizontalBarChart = [[HorizontalBarChartView alloc] init];
            self.horizontalBarChart.frame = self.chartContainerView.bounds;
            
            [self.chartContainerView addSubview:self.horizontalBarChart];
            [self setupPerQuestionChart];
            
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
    
    for (NSNumber *value in @[@(0), @(0.25f), @(0.50f), @(0.75f), @(1.0f)]) {
        ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:[value doubleValue]];
        
        limitLine.labelPosition = ChartLimitLabelPositionLeftBottom;
        limitLine.lineColor = [[RNThemeManager sharedManager] colorForKey:kELTextFieldBGColor];
        limitLine.lineWidth = 0.5f;
        limitLine.xOffset = 0;
        
        [barChart.leftAxis addLimitLine:limitLine];
    }
    
    barChart.noDataFont = dataFont;
    barChart.noDataText = [NSString stringWithFormat:NSLocalizedString(@"kELReportRestrictedData", nil),
                           @(kELParticipantsMinimumCount)];
    barChart.noDataTextColor = [[RNThemeManager sharedManager] colorForKey:kELOrangeColor];
    
    barChart.rightAxis.axisMaximum = 1.1f;
    barChart.rightAxis.axisMinimum = 0.0f;
    barChart.rightAxis.drawAxisLineEnabled = NO;
    barChart.rightAxis.drawGridLinesEnabled = NO;
    barChart.rightAxis.drawLabelsEnabled = NO;
    
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
    barChart.leftAxis.drawGridLinesEnabled = YES;
    barChart.leftAxis.drawLabelsEnabled = NO;
    barChart.leftAxis.drawTopYLabelEntryEnabled = YES;
    
    barChart.noDataFont = dataFont;
    barChart.noDataText = [NSString stringWithFormat:NSLocalizedString(@"kELReportRestrictedData", nil),
                           @(kELParticipantsMinimumCount)];
    barChart.noDataTextColor = [[RNThemeManager sharedManager] colorForKey:kELOrangeColor];
    
    barChart.rightAxis.axisMaximum = axisMax;
    barChart.rightAxis.axisMinimum = axisMin;
    barChart.rightAxis.drawAxisLineEnabled = NO;
    barChart.rightAxis.drawGridLinesEnabled = NO;
    barChart.rightAxis.drawLabelsEnabled = YES;
    barChart.rightAxis.labelCount = 10;
    barChart.rightAxis.labelFont = labelFont;
    barChart.rightAxis.labelTextColor = [UIColor whiteColor];
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

- (void)setupPerCategoryChart {
    NSMutableArray *mEntries, *mLabels;
    BarChartData *chartData;
    BarChartDataSet *chartDataSet;
    
    mEntries = [[NSMutableArray alloc] init];
    mLabels = [[NSMutableArray alloc] init];
    
    // NOTE: Dummy data
    for (int i = 0; i < 3; i++) {
        [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:0.5]];
        [mLabels addObject:[NSString stringWithFormat:@"%@", @(0.5f)]];
    }
    
    self.barChart = [self configureBarChart:self.barChart];
    self.barChart.legend.enabled = NO;
    
    self.barChart.xAxis.labelCount = mLabels.count;
    self.barChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:mLabels];
    
    chartDataSet = [self chartDataSetWithTitle:@""
                                         items:[mEntries copy]
                                      colorKey:kELGreenColor];
    chartData = [[BarChartData alloc] initWithDataSet:chartDataSet];
    chartData.barWidth = 0.5f;
    
    self.barChart.data = chartData;
    
    [self.barChart animateWithYAxisDuration:0.5];
}

- (void)setupPerQuestionChart {
    NSMutableArray *mEntries, *mLabels;
    BarChartData *chartData;
    BarChartDataSet *chartDataSet;
    
    mEntries = [[NSMutableArray alloc] init];
    mLabels = [[NSMutableArray alloc] init];
    
    // NOTE: Dummy data
    for (int i = 0; i < 2; i++) {
        [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:0.5]];
        [mLabels addObject:@"Others combined"];
    }
    
    self.horizontalBarChart = [self configureHorizontalBarChart:self.horizontalBarChart];
    self.horizontalBarChart.legend.enabled = NO;
    
    self.horizontalBarChart.xAxis.labelCount = mLabels.count;
    self.horizontalBarChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:mLabels];
    
    chartDataSet = [self chartDataSetWithTitle:@""
                                         items:[mEntries copy]
                                      colorKey:kELGreenColor];
    chartData = [[BarChartData alloc] initWithDataSet:chartDataSet];
    chartData.barWidth = 0.5f;
    
    self.horizontalBarChart.data = chartData;
    
    [self.horizontalBarChart animateWithYAxisDuration:0.5];
}

- (void)setupRadarChart {
    double axisMax, axisMin;
    NSMutableArray *mEntries, *mLabels;
    RadarChartData *chartData;
    RadarChartDataSet *chartDataSet, *chartDataSet2;
    UIFont *labelFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    
    axisMax = 1.1f, axisMin = 0.0f;
    
    mEntries = [[NSMutableArray alloc] init];
    mLabels = [[NSMutableArray alloc] init];
    
    // NOTE: Dummy data
    for (int i = 0; i < 3; i++) {
        [mEntries addObject:[[RadarChartDataEntry alloc] initWithValue:0.5]];
        [mLabels addObject:@"Test"];
    }
    
    chartDataSet = [[RadarChartDataSet alloc] initWithValues:mEntries];
    chartDataSet.colors = @[[[RNThemeManager sharedManager] colorForKey:kELOrangeColor]];
    chartDataSet.highlightEnabled = NO;
    chartDataSet.valueFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    
    // NOTE: Dummy data
    [mEntries removeAllObjects];
    [mLabels removeAllObjects];
    
    for (int i = 0; i < 3; i++) {
        [mEntries addObject:[[RadarChartDataEntry alloc] initWithValue:0.85]];
        [mLabels addObject:[NSString stringWithFormat:@"%@", @(0.85f)]];
    }
    
    chartDataSet2 = [[RadarChartDataSet alloc] initWithValues:mEntries];
    chartDataSet2.colors = @[[[RNThemeManager sharedManager] colorForKey:kELGreenColor]];
    chartDataSet2.highlightEnabled = NO;
    chartDataSet2.valueFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    
    chartData = [[RadarChartData alloc] initWithDataSet:chartDataSet];
    
    self.radarChart.chartDescription.enabled = NO;
    self.radarChart.data = chartData;
    self.radarChart.innerWebColor = [[RNThemeManager sharedManager] colorForKey:kELTextFieldBGColor];
    self.radarChart.webColor = [[RNThemeManager sharedManager] colorForKey:kELTextFieldBGColor];
    
    self.radarChart.legend.enabled = NO;
    
    self.radarChart.xAxis.axisMinimum = axisMin;
    self.radarChart.xAxis.axisMinimum = axisMax;
    self.radarChart.xAxis.drawAxisLineEnabled = NO;
    self.radarChart.xAxis.drawGridLinesEnabled = NO;
    self.radarChart.xAxis.labelFont = labelFont;
    self.radarChart.xAxis.labelTextColor = [UIColor whiteColor];
    self.radarChart.xAxis.xOffset = 0.0;
    self.radarChart.xAxis.yOffset = 0.0;
    
    self.radarChart.yAxis.axisMinimum = axisMin;
    self.radarChart.yAxis.axisMinimum = axisMax;
    self.radarChart.yAxis.drawAxisLineEnabled = NO;
    self.radarChart.yAxis.drawGridLinesEnabled = NO;
    self.radarChart.yAxis.labelFont = labelFont;
    self.radarChart.yAxis.labelCount = mLabels.count;
    
    [self.radarChart animateWithYAxisDuration:0.5];
}

@end
