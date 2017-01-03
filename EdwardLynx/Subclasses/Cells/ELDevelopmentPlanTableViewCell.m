//
//  ELDevelopmentPlanTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDevelopmentPlanTableViewCell.h"

@implementation ELDevelopmentPlanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Protocol Methods

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    ELDevelopmentPlan *plan = (ELDevelopmentPlan *)object;
    
    // Content
    self.developmentPlanLabel.text = plan.name;
    self.timestampLabel.text = plan.timestamp;
    self.statusLabel.text = [plan.status uppercaseString];
    
    // UI
    self.statusLabel.layer.cornerRadius = 2.0f;
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {
    //
}

@end
