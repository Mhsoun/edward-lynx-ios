//
//  ELListTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELListTableViewCell.h"
#import "ELFilterSortItem.h"

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
    self.item = (ELFilterSortItem *)object;
    self.titleLabel.text = self.item.title;
    
    [self toggleCellSelection];
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {
    self.item.selected = !self.item.selected;
    
    [self toggleCellSelection];
}

- (void)handleObject:(id)object deselectionActionAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Private Methods

- (void)toggleCellSelection {
    self.accessoryType = self.item.selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    self.titleLabel.textColor = [[RNThemeManager sharedManager] colorForKey:self.item.selected ? kELOrangeColor :
                                                                                                 kELTextFieldInputColor];
}

@end
