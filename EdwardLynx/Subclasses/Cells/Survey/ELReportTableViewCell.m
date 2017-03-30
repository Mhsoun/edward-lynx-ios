//
//  ELReportTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELReportTableViewCell.h"
#import "ELInstantFeedback.h"

@implementation ELReportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // UI
    self.invitedIcon.image = [FontAwesome imageWithIcon:fa_user
                                              iconColor:[UIColor whiteColor]
                                               iconSize:50];
    self.nextIcon.image = [FontAwesome imageWithIcon:fa_chevron_right
                                              iconColor:[[RNThemeManager sharedManager] colorForKey:kELOrangeColor]
                                               iconSize:50];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Protocol Methods

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    ELInstantFeedback *instantFeedback = (ELInstantFeedback *)object;
    
    // Content
    self.titleLabel.text = instantFeedback.question.text;
    self.typeLabel.text = [NSString stringWithFormat:@" %@ ", @"INSTANT FEEDBACK"];  // TEMP
    
    // UI
    self.timestampLabel.textColor = [[RNThemeManager sharedManager] colorForKey:kELTextFieldBGColor];
    self.typeLabel.backgroundColor = [[RNThemeManager sharedManager] colorForKey:kELFeedbackColor];
    self.typeLabel.layer.cornerRadius = 2.0f;
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {
    //
}

@end
