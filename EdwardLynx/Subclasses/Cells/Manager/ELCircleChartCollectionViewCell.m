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

//- (void)prepareForReuse {
//    [super prepareForReuse];
//    
//    [self.chartView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//}

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
    
    // Check if subview has already been added
    if ([self hasQuestionViewAsSubview:[self.circleChart class]]) {
        return;
    }
    
    [ELUtils circleChart:self.circleChart progress:self.devPlan.progress];
    
    [self.circleChart.countingLabel setFont:Font(@"Lato-Bold", 12.0f)];
    [self.circleChart setDisplayAnimated:NO];
    [self.circleChart strokeChart];
    
    [self.chartView addSubview:self.circleChart];
}

#pragma mark - Private Methods

- (BOOL)hasQuestionViewAsSubview:(Class)class {
    for (UIView *subview in self.chartView.subviews) {
        if ([subview isKindOfClass:class]) {
            return YES;
        }
    }
    
    return NO;
}

@end
