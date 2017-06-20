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

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization
    // NOTE Fix frame
    self.circleChart = [[PNCircleChart alloc] initWithFrame:self.chartView.bounds
                                                      total:[NSNumber numberWithInt:100]
                                                    current:[NSNumber numberWithInt:0]
                                                  clockwise:YES
                                                     shadow:YES
                                                shadowColor:ThemeColor(kELHeaderColor)
                                       displayCountingLabel:YES
                                          overrideLineWidth:[NSNumber numberWithInteger:12]];
    
    [self.chartView addSubview:self.circleChart];
}

- (void)customInit {
    [[NSBundle mainBundle] loadNibNamed:@"CircleChart" owner:self options:nil];
    [self addSubview:self.view];
    
    self.view.frame = self.bounds;
}

- (void)renderChart {
    [self.circleChart setDisplayAnimated:NO];
    [self.circleChart strokeChart];
}

- (void)setupContent:(NSDictionary *)detailsDict {
    self.nameLabel.text = detailsDict[@"name"];
    
    [ELUtils circleChart:self.circleChart progress:[detailsDict[@"percentage"] floatValue]];
}

@end
