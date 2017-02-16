//
//  ELParticipantTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 09/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELParticipantTableViewCell.h"
#import "ELParticipant.h"

@implementation ELParticipantTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    NSString *key = userInteractionEnabled ? kELWhiteColor : kELDarkGrayColor;
    
    [super setUserInteractionEnabled:userInteractionEnabled];
    
    self.nameLabel.textColor = [[RNThemeManager sharedManager] colorForKey:key];
    self.emailLabel.textColor = [[RNThemeManager sharedManager] colorForKey:key];
}

#pragma mark - Protocol Methods

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    ELParticipant *participant = (ELParticipant *)object;
    
    self.participant = participant;
    self.nameLabel.text = participant.name;
    self.emailLabel.text = participant.email;
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {
    self.participant.isSelected = !self.participant.isSelected;
}

@end
