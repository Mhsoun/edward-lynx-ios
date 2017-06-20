//
//  ELManagerIndividualTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELManagerIndividualTableViewCell.h"
#import "ELCircleChart.h"

@implementation ELManagerIndividualTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *individualDict = (NSDictionary *)object;
    NSArray *items = individualDict[@"data"];
    
    self.nameLabel.text = individualDict[@"name"];
    
    for (int i = 0; i < items.count; i++) {
        ELCircleChart *chartView = self.chartViews[i];
        
        [chartView setHidden:NO];
        [chartView setupContent:items[i]];
        [chartView renderChart];
    }
}

#pragma mark - Interface Builder Actions

- (IBAction)onSeeMoreButtonClick:(id)sender {
    
}

@end
