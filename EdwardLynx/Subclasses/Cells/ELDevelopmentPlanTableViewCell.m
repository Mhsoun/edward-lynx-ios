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
    ELDevelopmentPlan *devPlan = (ELDevelopmentPlan *)object;
    CGFloat progress = [[devPlan progressDetails][@"value"] floatValue];
    
    // Content
    self.nameLabel.text = devPlan.name;
    self.completedLabel.text = [devPlan progressDetails][@"text"];
    self.timestampLabel.text = [[ELAppSingleton sharedInstance].dateFormatter stringFromDate:devPlan.createdAt];
    
    // UI
    self.progressView.progress = progress;
    self.progressView.progressTintColor = [[RNThemeManager sharedManager] colorForKey:progress == 1 ? kELGreenColor :
                                                                                                      kELOrangeColor];
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {
    //
}

@end
