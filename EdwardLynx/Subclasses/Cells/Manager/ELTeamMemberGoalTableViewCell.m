//
//  ELTeamMemberGoalTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <PNChart/PNChart.h>

#import "ELTeamMemberGoalTableViewCell.h"

@interface ELTeamMemberGoalTableViewCell ()

@property (nonatomic, strong) PNCircleChart *circleChart;

@end

@implementation ELTeamMemberGoalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.circleChart = [[PNCircleChart alloc] initWithFrame:self.chartView.bounds
                                                      total:[NSNumber numberWithInt:100]
                                                    current:[NSNumber numberWithInt:0]
                                                  clockwise:YES
                                                     shadow:YES
                                                shadowColor:ThemeColor(kELHeaderColor)
                                       displayCountingLabel:YES
                                          overrideLineWidth:[NSNumber numberWithInteger:7]];
    
    [self.chartView addSubview:self.circleChart];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *detailsDict = (NSDictionary *)object;
    
    if (![detailsDict[@"chart"] boolValue]) {
        self.chartView.hidden = YES;
        
        return;
    }
        
    // Chart View
    [ELUtils circleChart:self.circleChart progress:[detailsDict[@"percentage"] floatValue]];
    
    self.circleChart.countingLabel.font = Font(@"Lato-Bold", 12.0f);
    
    [self.circleChart setDisplayAnimated:NO];
    [self.circleChart strokeChart];
}

#pragma mark - Interface Builder Action

- (void)onMoreButtonClick:(id)sender {
    
}

@end
