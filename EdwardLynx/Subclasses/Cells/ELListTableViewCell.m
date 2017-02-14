//
//  ELListTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELListTableViewCell.h"

@implementation ELListTableViewCell

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
    self.titleLabel.text = (NSString *)object;
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isSelected = self.accessoryType == UITableViewCellAccessoryCheckmark;
    
    self.accessoryType = isSelected ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    self.titleLabel.textColor = [[RNThemeManager sharedManager] colorForKey:isSelected ? kELTextFieldInputColor :
                                                                                         kELOrangeColor];
}

- (void)handleObject:(id)object deselectionActionAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
