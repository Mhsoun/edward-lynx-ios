//
//  ELDevelopmentPlanTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

@import Charts;

#import <PNChart/PNChart.h>

#import "ELDevelopmentPlanTableViewCell.h"
#import "ELDevelopmentPlan.h"

@interface ELDevelopmentPlanTableViewCell ()

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) BarChartView *barChart;
@property (nonatomic, strong) PNBarChart *pnBarChart;
@property (nonatomic, strong) PNCircleChart *circleChart;

@end

@implementation ELDevelopmentPlanTableViewCell

- (void)awakeFromNib {
    UITapGestureRecognizer *tap;
    
    [super awakeFromNib];
    
    // Initialization code
    self.pnBarChart = [[PNBarChart alloc] init];
    self.barChart = [[BarChartView alloc] initWithFrame:self.scrollView.bounds];
    self.circleChart = [[PNCircleChart alloc] initWithFrame:self.circleChartView.bounds
                                                      total:[NSNumber numberWithInt:100]
                                                    current:[NSNumber numberWithInt:0]
                                                  clockwise:YES
                                                     shadow:YES
                                                shadowColor:ThemeColor(kELHeaderColor)
                                       displayCountingLabel:YES
                                          overrideLineWidth:[NSNumber numberWithInteger:12]];
    
    [self.barChartView addSubview:self.barChart];
    [self.circleChartView addSubview:self.circleChart];
    
    [self.moreBarChartButton setTintColor:[UIColor whiteColor]];
    [self.moreBarChartButton setImage:[FontAwesome imageWithIcon:fa_angle_right
                                                       iconColor:nil
                                                        iconSize:20]
                             forState:UIControlStateNormal];
    
    // Scroll View
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScrollViewTap:)];
    tap.numberOfTapsRequired = 1;
    tap.enabled = YES;
    tap.cancelsTouchesInView = NO;
    
    [self.scrollView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Protocol Methods

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    NSString *colorKey;
    ELDevelopmentPlan *devPlan = (ELDevelopmentPlan *)object;
    
    self.indexPath = indexPath;
    
    // Content
    self.nameLabel.text = devPlan.name;
    self.completedLabel.text = devPlan.progressText;
    self.timestampLabel.text = [AppSingleton.printDateFormatter stringFromDate:devPlan.createdAt];
    
    [self setupBarChartForDevelopmentPlan:devPlan];
    [self setupCircleChartForDevelopmentPlan:devPlan];
    
    // UI
    colorKey = devPlan.completed ? kELOrangeColor : kELBlueColor;
    
    self.completedLabel.textColor = ThemeColor(colorKey);
    self.moreBarChartButton.hidden = CGRectGetWidth(self.scrollView.frame) >= CGRectGetWidth(self.barChartView.frame);
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {
    //
}

#pragma mark - Private Methods

- (void)onScrollViewTap:(UIGestureRecognizer *)recognizer {
    [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:self.indexPath];
}

- (void)setupBarChartForDevelopmentPlan:(ELDevelopmentPlan *)devPlan {
    NSInteger visibleCount;
    BarChartData *chartData;
    BarChartDataSet *chartDataSet;
    NSMutableArray *mColors = [[NSMutableArray alloc] init];
    NSMutableArray *mLabels = [[NSMutableArray alloc] init];
    NSMutableArray<BarChartDataEntry *> *mEntries = [[NSMutableArray alloc] init];
    
    if (devPlan.goals.count > 0) {
        for (int i = 0; i < devPlan.goals.count; i++) {
            double progress;
            NSString *colorKey;
            ELGoal *goal = devPlan.goals[i];
            
            progress = [[goal progressDetails][@"value"] doubleValue];
            colorKey = progress == 1 ? kELOrangeColor : kELBlueColor;
            
            [mColors addObject:ThemeColor(colorKey)];
            [mLabels addObject:Format(@"%@", @(i + 1)]);
            [mEntries addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:progress]];
        }
        
        chartDataSet = [[BarChartDataSet alloc] initWithValues:[mEntries copy] label:@"Dev Plan"];
        chartDataSet.colors = [mColors copy];
        chartDataSet.drawValuesEnabled = NO;
    } else {
        [mLabels addObject:@""];
        [mEntries addObject:[[BarChartDataEntry alloc] initWithX:0.0 y:0.0]];
        
        chartDataSet = [[BarChartDataSet alloc] initWithValues:[mEntries copy] label:@"Dev Plan"];
        chartDataSet.drawValuesEnabled = NO;
    }
    
    chartData = [[BarChartData alloc] initWithDataSet:chartDataSet];
    chartData.barWidth = 0.9f;
    
    visibleCount = 15;
    
    self.barChart.chartDescription.enabled = NO;
    self.barChart.doubleTapToZoomEnabled = NO;
    self.barChart.drawBarShadowEnabled = NO;
    self.barChart.drawGridBackgroundEnabled = NO;
    self.barChart.highlightPerTapEnabled = NO;
    self.barChart.maxVisibleCount = visibleCount;
    self.barChart.pinchZoomEnabled = NO;
    
    self.barChart.leftAxis.axisLineColor = [UIColor blackColor];
    self.barChart.leftAxis.axisMaximum = 1.0f;
    self.barChart.leftAxis.axisMinimum = 0.0f;
    self.barChart.leftAxis.drawGridLinesEnabled = NO;
    self.barChart.leftAxis.drawLabelsEnabled = NO;
    
    self.barChart.legend.enabled = NO;
    self.barChart.rightAxis.drawAxisLineEnabled = NO;
    self.barChart.rightAxis.drawGridLinesEnabled = NO;
    self.barChart.rightAxis.drawLabelsEnabled = NO;
    
    self.barChart.xAxis.axisLineColor = [UIColor blackColor];
    self.barChart.xAxis.drawGridLinesEnabled = NO;
    self.barChart.xAxis.granularity = 1;
    self.barChart.xAxis.labelFont = [UIFont fontWithName:@"Lato-Regular" size:10];
    self.barChart.xAxis.labelCount = [mLabels count];
    self.barChart.xAxis.labelPosition = XAxisLabelPositionBottom;
    self.barChart.xAxis.labelTextColor = [UIColor whiteColor];
    self.barChart.xAxis.valueFormatter = [ChartIndexAxisValueFormatter withValues:[mLabels copy]];
    
    self.barChart.data = chartData;
    
    [self.barChart setVisibleXRangeMaximum:visibleCount];
    [self.barChart setVisibleXRangeMinimum:visibleCount];
}

- (void)setupPNBarChartForDevelopmentPlan:(ELDevelopmentPlan *)devPlan {
    CGFloat width;
    CGRect frame;
    NSMutableArray *mColors = [[NSMutableArray alloc] init];
    NSMutableArray *mLabels = [[NSMutableArray alloc] init];
    NSMutableArray *mValues = [[NSMutableArray alloc] init];
    
    self.pnBarChart.backgroundColor = [UIColor clearColor];
    self.pnBarChart.barBackgroundColor = [UIColor clearColor];
    self.pnBarChart.barRadius = 0;
    self.pnBarChart.barWidth = 20;
    self.pnBarChart.chartBorderColor = ThemeColor(kELHeaderColor);
    self.pnBarChart.chartMarginBottom = 0;
    self.pnBarChart.chartMarginTop = 0;
    self.pnBarChart.isGradientShow = NO;
    self.pnBarChart.isShowNumbers = NO;
    self.pnBarChart.labelFont = [UIFont fontWithName:@"Lato-Regular" size:8];
    self.pnBarChart.labelMarginTop = 0;
    self.pnBarChart.labelTextColor = [UIColor whiteColor];
    self.pnBarChart.showChartBorder = YES;
    self.pnBarChart.yChartLabelWidth = 0;
    
    width = (self.pnBarChart.barWidth * devPlan.goals.count) * 2;
    
    [self.barChartWidthConstraint setConstant:width];
    [self.barChartView layoutIfNeeded];
    
    frame = CGRectGetWidth(self.scrollView.bounds) > width ? self.scrollView.bounds : self.barChartView.bounds;
    
    self.pnBarChart.frame = frame;
    
    for (int i = 0; i < devPlan.goals.count; i++) {
        ELGoal *goal = devPlan.goals[i];
        NSString *colorKey = [[goal progressDetails][@"value"] floatValue] == 1 ? kELOrangeColor : kELBlueColor;
        
        [mColors addObject:ThemeColor(colorKey)];
        [mLabels addObject:Format(@"%@", @(i + 1)]);
        [mValues addObject:@([[goal progressDetails][@"value"] floatValue])];
    }
    
    self.pnBarChart.yMaxValue = 1.0f;
    self.pnBarChart.strokeColors = [mColors copy];
    self.pnBarChart.xLabels = [mLabels copy];
    self.pnBarChart.yValues = [mValues copy];
    
    [self.pnBarChart strokeChart];
}

- (void)setupCircleChartForDevelopmentPlan:(ELDevelopmentPlan *)devPlan {
    [ELUtils circleChart:self.circleChart developmentPlan:devPlan];
    
    [self.circleChart setDisplayAnimated:NO];
    [self.circleChart strokeChart];
}

#pragma mark - Interface Builder Actions

- (IBAction)onMoreBarChartButtonClick:(id)sender {
    CGPoint rightOffset = CGPointMake(self.scrollView.contentSize.width - self.scrollView.bounds.size.width, 0);
    
    [self.scrollView setContentOffset:rightOffset animated:YES];
}

@end
