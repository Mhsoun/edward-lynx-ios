//
//  ELDevelopmentPlanTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <PNChart/PNChart.h>

#import "ELDevelopmentPlanTableViewCell.h"
#import "ELDevelopmentPlan.h"

@interface ELDevelopmentPlanTableViewCell ()

@property (nonatomic, strong) PNBarChart *barChart;
@property (nonatomic, strong) PNCircleChart *circleChart;

@end

@implementation ELDevelopmentPlanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.barChart = [[PNBarChart alloc] initWithFrame:self.barChartView.bounds];
    self.circleChart = [[PNCircleChart alloc] initWithFrame:self.circleChartView.bounds
                                                      total:[NSNumber numberWithInt:100]
                                                    current:[NSNumber numberWithInt:0]
                                                  clockwise:YES
                                                     shadow:YES
                                                shadowColor:[[RNThemeManager sharedManager] colorForKey:kELHeaderColor]
                                       displayCountingLabel:YES
                                          overrideLineWidth:[NSNumber numberWithInteger:12]];
    
    [self.barChartView addSubview:self.barChart];
    [self.circleChartView addSubview:self.circleChart];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Protocol Methods

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    ELDevelopmentPlan *devPlan = (ELDevelopmentPlan *)object;
    
    // Content
    self.nameLabel.text = devPlan.name;
    self.completedLabel.text = devPlan.progressText;
    self.timestampLabel.text = [[ELAppSingleton sharedInstance].printDateFormatter stringFromDate:devPlan.createdAt];
    
    [self setupBarChartForDevelopmentPlan:devPlan];
    [self setupCircleChartForDevelopmentPlan:devPlan];
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {
    //
}

#pragma mark - Private Methods

- (void)setupBarChartForDevelopmentPlan:(ELDevelopmentPlan *)devPlan {
    NSMutableArray *mColors = [[NSMutableArray alloc] init];
    NSMutableArray *mLabels = [[NSMutableArray alloc] init];
    NSMutableArray *mValues = [[NSMutableArray alloc] init];
    
    self.barChart.backgroundColor = [UIColor clearColor];
    self.barChart.barBackgroundColor = [UIColor clearColor];
    self.barChart.barRadius = 0;
    self.barChart.barWidth = 20;
    self.barChart.isGradientShow = NO;
    self.barChart.isShowNumbers = NO;
    self.barChart.labelFont = [UIFont fontWithName:@"Lato-Regular" size:8];
    self.barChart.labelMarginTop = 25;
    self.barChart.labelTextColor = [UIColor whiteColor];
    self.barChart.yChartLabelWidth = 0;
    
    for (int i = 0; i < devPlan.goals.count; i++) {
        ELGoal *goal = devPlan.goals[i];
        NSString *colorKey = [[goal progressDetails][@"value"] floatValue] == 1 ? kELOrangeColor : kELGreenColor;
        
        [mColors addObject:[[RNThemeManager sharedManager] colorForKey:colorKey]];
        [mLabels addObject:[NSString stringWithFormat:@"%@", @(i + 1)]];
        [mValues addObject:@([[goal progressDetails][@"value"] floatValue])];
    }
    
    self.barChart.yMaxValue = 1.0f;
    self.barChart.strokeColors = [mColors copy];
    self.barChart.xLabels = [mLabels copy];
    self.barChart.yValues = [mValues copy];
    
    [self.barChart strokeChart];
}

- (void)setupCircleChartForDevelopmentPlan:(ELDevelopmentPlan *)devPlan {
    self.circleChart.backgroundColor = [UIColor clearColor];
    self.circleChart.strokeColor = [[RNThemeManager sharedManager] colorForKey:kELOrangeColor];
    self.circleChart.current = [NSNumber numberWithFloat:(devPlan.progress * 100)];

    self.circleChart.countingLabel.font = [UIFont fontWithName:@"Lato-Bold" size:20.0f];
    self.circleChart.countingLabel.textColor = [UIColor whiteColor];
    
    [self.circleChart strokeChart];
}

@end
