//
//  ELParticipantTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 09/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELParticipantTableViewCell.h"

@implementation ELParticipantTableViewCell

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
    ELParticipant *participant = (ELParticipant *)object;
    
    self.nameLabel.text = participant.name;
    self.emailLabel.text = participant.email;
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {
    self.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)handleObject:(id)object deselectionActionAtIndexPath:(NSIndexPath *)indexPath {
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end
