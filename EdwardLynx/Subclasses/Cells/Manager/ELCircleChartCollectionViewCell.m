//
//  ELCircleChartCollectionViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <PNChart/PNChart.h>

#import "ELCircleChartCollectionViewCell.h"
#import "ELDevelopmentPlan.h"

@interface ELCircleChartCollectionViewCell ()

@property (nonatomic, strong) ELDevelopmentPlan *devPlan;
@property (nonatomic, strong) PNCircleChart *circleChart;

@end

@implementation ELCircleChartCollectionViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Update content
    [self.chartView layoutIfNeeded];
    [self setupContent];
}

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    self.devPlan = (ELDevelopmentPlan *)object;
}

- (void)setupContent {
    self.nameLabel.text = self.devPlan.name;
    self.circleChart = [[PNCircleChart alloc] initWithFrame:self.chartView.bounds
                                                      total:[NSNumber numberWithInt:100]
                                                    current:[NSNumber numberWithInt:0]
                                                  clockwise:YES
                                                     shadow:YES
                                                shadowColor:ThemeColor(kELHeaderColor)
                                       displayCountingLabel:YES
                                          overrideLineWidth:[NSNumber numberWithInteger:8]];
    
    [ELUtils circleChart:self.circleChart progress:self.devPlan.progress];
    
    [self.circleChart.countingLabel setFont:Font(@"Lato-Bold", 12.0f)];
    [self.circleChart setDisplayAnimated:NO];
    [self.circleChart strokeChart];
    
    [self.chartView addSubview:self.circleChart];
}

@end
