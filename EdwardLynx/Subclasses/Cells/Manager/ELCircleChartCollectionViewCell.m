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
#import "ELTeamDevelopmentPlan.h"

@interface ELCircleChartCollectionViewCell ()

@property (nonatomic, strong) ELDevelopmentPlan *devPlan;
@property (nonatomic, strong) ELTeamDevelopmentPlan *teamDevPlan;
@property (nonatomic, strong) PNCircleChart *circleChart;

@end

@implementation ELCircleChartCollectionViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization
    self.devPlan = nil;
    self.teamDevPlan = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Update content
    [self.chartView layoutIfNeeded];
    [self setupContent];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.devPlan = nil;
    self.teamDevPlan = nil;
}

#pragma mark - Public Methods

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    if ([object isKindOfClass:[ELDevelopmentPlan class]]) {
        self.devPlan = (ELDevelopmentPlan *)object;
    } else {
        self.teamDevPlan = (ELTeamDevelopmentPlan *)object;
    }
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

- (void)setupContent {
    CGFloat progress = self.devPlan ? self.devPlan.progress : self.teamDevPlan.progress;
    NSString *name = self.devPlan ? self.devPlan.name : self.teamDevPlan.name;
    
    // Check if subview has already been added
    if ([self hasQuestionViewAsSubview:[self.circleChart class]]) {
        return;
    }
    
    self.nameLabel.text = name;
    self.circleChart = [[PNCircleChart alloc] initWithFrame:self.chartView.bounds
                                                      total:[NSNumber numberWithInt:100]
                                                    current:[NSNumber numberWithInt:0]
                                                  clockwise:YES
                                                     shadow:YES
                                                shadowColor:ThemeColor(kELHeaderColor)
                                       displayCountingLabel:YES
                                          overrideLineWidth:[NSNumber numberWithInteger:8]];
    
    [ELUtils circleChart:self.circleChart progress:progress];
    
    [self.circleChart.countingLabel setFont:Font(@"Lato-Bold", 12.0f)];
    [self.circleChart setDisplayAnimated:NO];
    [self.circleChart strokeChart];
    
    [self.chartView addSubview:self.circleChart];
}

@end
