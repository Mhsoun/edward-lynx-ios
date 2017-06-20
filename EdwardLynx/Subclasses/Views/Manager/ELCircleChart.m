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
    CGFloat size;
    
    [super awakeFromNib];
    
    size = CGRectGetWidth(self.bounds) / 1.75;
    
    // Initialization
    // NOTE Workaroud for subview frame not adjusting
    self.circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 0,
                                                                       CGRectGetWidth(self.bounds), size)
                                                      total:[NSNumber numberWithInt:100]
                                                    current:[NSNumber numberWithInt:0]
                                                  clockwise:YES
                                                     shadow:YES
                                                shadowColor:ThemeColor(kELHeaderColor)
                                       displayCountingLabel:YES
                                          overrideLineWidth:[NSNumber numberWithInteger:7]];
    
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
    self.circleChart.countingLabel.font = Font(@"Lato-Bold", 10.0f);
    
    [ELUtils circleChart:self.circleChart progress:[detailsDict[@"percentage"] floatValue]];
}

@end
