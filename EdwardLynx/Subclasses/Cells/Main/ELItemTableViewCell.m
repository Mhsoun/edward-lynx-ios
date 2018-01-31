//
//  ELItemTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 18/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELItemTableViewCell.h"

#pragma mark - Private Constants

static CGFloat const kELIconSize = 15;

@implementation ELItemTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // UI
    [self.deleteButton setImage:[FontAwesome imageWithIcon:fa_times
                                                 iconColor:ThemeColor(kELOrangeColor)
                                                  iconSize:kELIconSize
                                                 imageSize:CGSizeMake(kELIconSize, kELIconSize)]
                       forState:UIControlStateNormal];
    [self.editButton setImage:[FontAwesome imageWithIcon:fa_pencil
                                               iconColor:ThemeColor(kELOrangeColor)
                                                iconSize:kELIconSize
                                               imageSize:CGSizeMake(kELIconSize, kELIconSize)]
                     forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Interface Builder Actions

- (IBAction)onDeleteButtonClick:(id)sender {
    [self.delegate onDeletionAtRow:self.tag];
}

- (IBAction)onEditButtonClick:(id)sender {
    [self.delegate onUpdateAtRow:self.tag];
}

@end
