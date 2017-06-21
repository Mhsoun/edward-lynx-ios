//
//  ELCircleChart.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELCircleChart.h"

#pragma mark - Class Extension

@interface ELCircleChart ()

@property (nonatomic, strong) NSDictionary *detailsDict;
@property (nonatomic, strong) PNCircleChart *circleChart;

@end

@implementation ELCircleChart

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (!self) {
        return nil;
    }
    
    [self customInit];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    [self customInit];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.chartView layoutIfNeeded];
    [self setupChartView];
}

- (void)customInit {
    [[NSBundle mainBundle] loadNibNamed:@"CircleChart" owner:self options:nil];
    [self addSubview:self.view];
    
    self.view.frame = self.bounds;
}

- (void)setupChartView {
    self.nameLabel.text = self.detailsDict[@"name"];
    self.circleChart = [[PNCircleChart alloc] initWithFrame:self.chartView.bounds
                                                      total:[NSNumber numberWithInt:100]
                                                    current:[NSNumber numberWithInt:0]
                                                  clockwise:YES
                                                     shadow:YES
                                                shadowColor:ThemeColor(kELHeaderColor)
                                       displayCountingLabel:YES
                                          overrideLineWidth:[NSNumber numberWithInteger:8]];
    
    [ELUtils circleChart:self.circleChart progress:[self.detailsDict[@"percentage"] floatValue]];
    
    self.circleChart.countingLabel.font = Font(@"Lato-Bold", 10.0f);
    
    [self.circleChart setDisplayAnimated:NO];
    [self.circleChart strokeChart];
    [self.chartView addSubview:self.circleChart];
}

- (void)setupContent:(NSDictionary *)detailsDict {
    self.detailsDict = detailsDict;
}

@end
