//
//  ELReportChartTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

@import Charts;

#import "ELReportChartTableViewCell.h"

#pragma mark - Private Constants

static NSString * const kELSelfColor = @"selfColor";

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    kELReportChartType type;
    NSDictionary *dataDict;
    CGRect frame = self.chartContainerView.frame;
    NSDictionary *detailDict = (NSDictionary *)object;
    
    self.titleLabel.text = detailDict[@"title"];
    type = [detailDict[@"type"] integerValue];
    
    switch (type) {
        case kELReportChartTypeBar:
            if ([self hasClassViewAsSubview:[BarChartView class]]) {
                return;
            }
            
            self.barChart = [[BarChartView alloc] initWithFrame:frame];
            
            [self.chartContainerView addSubview:self.barChart];
            [self setupPerCategoryChartWithData:detailDict[@"data"]];
            
            break;
        case kELReportChartTypeHorizontalBar:
        case kELReportChartTypeHorizontalBarBlindspot:
        case kELReportChartTypeHorizontalBarBreakdown:
            if ([self hasClassViewAsSubview:[HorizontalBarChartView class]]) {
                return;
            }
            
            frame.size.height = 140;
            
            self.horizontalBarChart = [[HorizontalBarChartView alloc] initWithFrame:frame];
            
            [self.chartContainerView addSubview:self.horizontalBarChart];
            
            if (type == kELReportChartTypeHorizontalBar) {
                [self setupPerQuestionChartWithData:detailDict[@"data"]];
            } else if (type == kELReportChartTypeHorizontalBarBlindspot) {
                [self setupBlindspotChartWithData:detailDict[@"data"]];
            } else {
                [self setupPerParticipantChartWithData:detailDict[@"data"]];
            }
            
            break;
        case kELReportChartTypePie:
            if ([self hasClassViewAsSubview:[PieChartView class]]) {
                return;
            }
            
            dataDict = detailDict[@"data"];
            frame.size.height = 450;
            
            self.pieChart = [[PieChartView alloc] initWithFrame:frame];
            self.titleLabel.text = dataDict[@"category"];
            
            [self.chartContainerView addSubview:self.pieChart];
            [self setupPieChartWithData:dataDict];
            
            break;
        case kELReportChartTypeRadar:
            if ([self hasClassViewAsSubview:[RadarChartView class]]) {
                return;
            }
            
            frame.size.height = 450;
            
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
    UIColor *color = [[RNThemeManager sharedManager] colorForKey:colorKey];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.minimumFractionDigits = 0;
    formatter.numberStyle = NSNumberFormatterPercentStyle;
    
    dataSet = [[BarChartDataSet alloc] initWithValues:items label:title];
    dataSet.colors = @[color];
    dataSet.highlightEnabled = NO;
    dataSet.valueFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    dataSet.valueFormatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:formatter];
    
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

- (BOOL)hasClassViewAsSubview:(Class)class {
    for (UIView *subview in self.chartContainerView.subviews) {
        if ([subview isKindOfClass:class]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)setupBlindspotChartWithData:(NSDictionary *)data {
    NSMutableArray *mColors,
                   *mEntries,
                   *mLabels;
    BarChartData *chartData;
    BarChartDataSet *chartDataSet;
    BarChartDataEntry *entry;
    
    mColors = [[NSMutableArray alloc] init];
    mEntries = [[NSMutableArray alloc] init];
    mLabels = [[NSMutableArray alloc] init];
    
//    for (int i = 0; i < 2; i++) {
//        NSDictionary *itemDict = items[i];
//        NSString *title = [itemDict[@"Title"] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//        NSString *colorKey = [itemDict[@"role_style"] isEqualToString:kELSelfColor] ? kELVioletColor : kELOrangeColor;
//        
//        entry = [[BarChartDataEntry alloc] initWithX:(double)i y:[itemDict[@"Percentage"] doubleValue]];
//        
//        [mEntries addObject:entry];
//        [mLabels addObject:title];
//        [mColors addObject:ThemeColor(colorKey)];
//    }
    
    entry = [[BarChartDataEntry alloc] initWithX:(double)0 y:[data[@"self"] doubleValue] / 100.0];
    
    [mEntries addObject:entry];
    [mLabels addObject:data[@"category"]];
    [mColors addObject:ThemeColor(kELOrangeColor)];
    
    entry = [[BarChartDataEntry alloc] initWithX:(double)1 y:[data[@"others"] doubleValue] / 100.0];
    
    [mEntries addObject:entry];
    [mLabels addObject:data[@"category"]];
    [mColors addObject:ThemeColor(kELOrangeColor)];
    
    self.horizontalBarChart = [self configureHorizontalBarChart:self.horizontalBarChart];
    self.horizontalBarChart.legend.enabled = NO;
    
    self.horizontalBarChart.leftAxis.drawGridLinesEnabled = NO;
    self.horizontalBarChart.leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    for (NSNumber *value in @[@(0), @(0.7f), @(1.0f)]) {
        ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:[value doubleValue]];
        
        limitLine.labelPosition = ChartLimitLabelPositionLeftBottom;
        limitLine.lineColor = [[RNThemeManager sharedManager] colorForKey:kELTextFieldBGColor];
        limitLine.lineWidth = 0.5f;
        limitLine.xOffset = 0;
        
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
    chartDataSet.valueFormatter = [ChartDefaultValueFormatter withBlock:^NSString * _Nonnull(double value, ChartDataEntry * _Nonnull entry, NSInteger i, ChartViewPortHandler * _Nullable handler) {
        int percentage = (int)ceil((value * 100));
        
        return [NSString stringWithFormat:@"%@", @(percentage)];
    }];
    chartDataSet.valueColors = [mColors copy];
    
    chartData = [[BarChartData alloc] initWithDataSet:chartDataSet];
    chartData.barWidth = 0.5f;
    
    self.horizontalBarChart.data = chartData;
}

- (void)setupPerCategoryChartWithData:(NSDictionary *)data {
    NSMutableArray *mEntries;
    BarChartData *chartData;
    BarChartDataSet *chartDataSet;
    
    mEntries = [[NSMutableArray alloc] init];
    
    [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)0
                                                           y:[data[@"Percentage"] doubleValue]]];
    [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)1
                                                           y:[data[@"Percentage_1"] doubleValue]]];
    
    self.barChart = [self configureBarChart:self.barChart];
    self.barChart.legend.enabled = NO;
    
    // TODO: Labels by 0, 25, 50, 75, 100
    
    self.barChart.leftAxis.drawLimitLinesBehindDataEnabled = YES;
    self.barChart.leftAxis.valueFormatter = [ChartDefaultAxisValueFormatter withBlock:^NSString * _Nonnull(double value, ChartAxisBase * _Nullable base) {
        int percentage = (int)ceil((value * 100));
        
        return [NSString stringWithFormat:@"%@%%", @(percentage)];
    }];
    
    chartDataSet = [self chartDataSetWithTitle:@""
                                         items:[mEntries copy]
                                      colorKey:kELGreenColor];
    chartData = [[BarChartData alloc] initWithDataSet:chartDataSet];
    chartData.barWidth = 0.5f;
    
    self.barChart.data = chartData;
}

- (void)setupPerParticipantChartWithData:(NSDictionary *)data {
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
        NSDictionary *itemDict = items[i];
        NSString *title = [itemDict[@"Title"] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *colorKey = [itemDict[@"role_style"] isEqualToString:kELSelfColor] ? kELVioletColor : kELOrangeColor;
        
        entry = [[BarChartDataEntry alloc] initWithX:(double)i y:[itemDict[@"Percentage"] doubleValue]];
        
        [mEntries addObject:entry];
        [mLabels addObject:title];
        [mColors addObject:ThemeColor(colorKey)];
    }
    
    self.horizontalBarChart = [self configureHorizontalBarChart:self.horizontalBarChart];
    self.horizontalBarChart.legend.enabled = NO;
    
    self.horizontalBarChart.leftAxis.drawGridLinesEnabled = NO;
    self.horizontalBarChart.leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    for (NSNumber *value in @[@(0), @(0.7f), @(1.0f)]) {
        ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:[value doubleValue]];
        
        limitLine.labelPosition = ChartLimitLabelPositionLeftBottom;
        limitLine.lineColor = [[RNThemeManager sharedManager] colorForKey:kELTextFieldBGColor];
        limitLine.lineWidth = 0.5f;
        limitLine.xOffset = 0;
        
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
    chartDataSet.valueFormatter = [ChartDefaultValueFormatter withBlock:^NSString * _Nonnull(double value, ChartDataEntry * _Nonnull entry, NSInteger i, ChartViewPortHandler * _Nullable handler) {
        int percentage = (int)ceil((value * 100));
        
        return [NSString stringWithFormat:@"%@", @(percentage)];
    }];
    chartDataSet.valueColors = [mColors copy];
    
    chartData = [[BarChartData alloc] initWithDataSet:chartDataSet];
    chartData.barWidth = 0.5f;
    
    self.horizontalBarChart.data = chartData;
}

- (void)setupPerQuestionChartWithData:(NSDictionary *)data {
    NSMutableArray *mEntries, *mLabels;
    BarChartData *chartData;
    BarChartDataSet *chartDataSet;
    
    mEntries = [[NSMutableArray alloc] init];
    mLabels = [[NSMutableArray alloc] init];
    
    [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)0
                                                           y:[data[@"Percentage"] doubleValue]]];
    [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)1
                                                           y:[data[@"Percentage_1"] doubleValue]]];
    [mLabels addObject:@"Others combined"];
    [mLabels addObject:@"Candidates"];
    
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
}

- (void)setupPieChartWithData:(NSDictionary *)data {
    double yesValue, noValue;
    PieChartDataEntry *entry;
    PieChartDataSet *chartDataSet;
    UIFont *labelFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    NSMutableArray *mEntries = [[NSMutableArray alloc] init];
    
    yesValue = [data[@"yesPercentage"] doubleValue];
    noValue = [data[@"noPercentage"] doubleValue];
    
    entry = [[PieChartDataEntry alloc] initWithValue:noValue label:@"No"];
    
    [mEntries addObject:entry];

    entry = [[PieChartDataEntry alloc] initWithValue:yesValue label:@"Yes"];
    
    [mEntries addObject:entry];
    
    chartDataSet = [[PieChartDataSet alloc] initWithValues:[mEntries copy] label:@""];
    chartDataSet.colors = @[ThemeColor(kELGreenColor), ThemeColor(kELOrangeColor)];
    
    self.pieChart.chartDescription.enabled = NO;
    self.pieChart.drawCenterTextEnabled = NO;
    self.pieChart.drawEntryLabelsEnabled = NO;
    self.pieChart.drawHoleEnabled = NO;
    
    self.pieChart._defaultValueFormatter = [ChartDefaultValueFormatter withBlock:^NSString * _Nonnull(double value, ChartDataEntry * _Nonnull entry, NSInteger i, ChartViewPortHandler * _Nullable handler) {
        NSDictionary *attributes = @{NSFontAttributeName: labelFont,
                                     NSForegroundColorAttributeName: ThemeColor(kELBlueColor)};
        
        // TODO Attributes not working
        
        return [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%", @(value)]
                                                attributes:attributes] string];
    }];
    
    self.pieChart.legend.font = labelFont;
    self.pieChart.legend.textColor = [UIColor whiteColor];
    self.pieChart.legend.position = ChartLegendPositionRightOfChartCenter;
    
    self.pieChart.noDataFont = labelFont;
    self.pieChart.noDataText = NSLocalizedString(@"kELReportNoData", nil);
    self.pieChart.noDataTextColor = ThemeColor(kELOrangeColor);
    
    // TODO Font of actual value
    
    self.pieChart.data = [[PieChartData alloc] initWithDataSet:chartDataSet];
}

- (void)setupRadarChartWithData:(NSArray *)items {
    double axisMax, axisMin;
    NSMutableArray *mDataSets, *mEntries, *mEntries2, *mLabels;
    RadarChartData *chartData;
    RadarChartDataSet *chartDataSet;
    UIFont *labelFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    
    axisMax = 1.0f, axisMin = 0.0f;
    
    mDataSets = [[NSMutableArray alloc] init];
    mEntries = [[NSMutableArray alloc] init];
    mEntries2 = [[NSMutableArray alloc] init];
    mLabels = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < items.count; j++) {
            NSDictionary *itemDict = items[j];
            NSDictionary *role = [itemDict[@"roles"] objectAtIndex:i];
//            RadarChartDataEntry *entry = [[RadarChartDataEntry alloc] initWithValue:[role[@"average"] doubleValue]];
            RadarChartDataEntry *entry = [[RadarChartDataEntry alloc] initWithValue:0.5];
            
            if (i == 0) {
                [mEntries addObject:entry];
            } else {
                [mEntries2 addObject:entry];
            }
            
            [mLabels addObject:itemDict[@"name"]];
        }
        
        chartDataSet = [[RadarChartDataSet alloc] initWithValues:i == 0 ? mEntries : mEntries2];
        chartDataSet.colors = @[[[RNThemeManager sharedManager] colorForKey:i == 0 ? kELOrangeColor : kELGreenColor]];
        chartDataSet.highlightEnabled = NO;
        chartDataSet.valueFont = [UIFont fontWithName:@"Lato-Regular" size:10];
        
        [mDataSets addObject:chartDataSet];
    }
    
    chartData = [[RadarChartData alloc] initWithDataSets:[mDataSets copy]];
    
    self.radarChart.chartDescription.enabled = NO;
    self.radarChart.innerWebColor = ThemeColor(kELTextFieldBGColor);
    self.radarChart.rotationEnabled = NO;
    self.radarChart.webColor = ThemeColor(kELTextFieldBGColor);

    self.radarChart.noDataFont = labelFont;
    self.radarChart.noDataText = NSLocalizedString(@"kELReportNoData", nil);
    self.radarChart.noDataTextColor = ThemeColor(kELOrangeColor);

    self.radarChart.xAxis.axisMinimum = axisMin;
    self.radarChart.xAxis.axisMaximum = axisMax;
    self.radarChart.xAxis.drawAxisLineEnabled = NO;
    self.radarChart.xAxis.drawGridLinesEnabled = NO;
    self.radarChart.xAxis.labelFont = labelFont;
    self.radarChart.xAxis.labelCount = mLabels.count;
    self.radarChart.xAxis.labelTextColor = [UIColor whiteColor];
    self.radarChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:mLabels];
    self.radarChart.xAxis.xOffset = 0.0;
    self.radarChart.xAxis.yOffset = 0.0;

    self.radarChart.yAxis.axisMinimum = axisMin;
    self.radarChart.yAxis.axisMaximum = axisMax;
    self.radarChart.yAxis.drawAxisLineEnabled = NO;
    self.radarChart.yAxis.drawGridLinesEnabled = NO;
    self.radarChart.yAxis.xOffset = 0.0;
    self.radarChart.yAxis.yOffset = 0.0;
    
    self.radarChart.data = chartData;
}

@end
