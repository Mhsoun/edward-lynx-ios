//
//  ELMenuTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 19/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELMenuTableViewCell.h"

@implementation ELMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state    
    // Change selected cell background color
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.selectedBackgroundView.frame];
    
    [backgroundView setBackgroundColor:[[RNThemeManager sharedManager] colorForKey:kELHeaderColor]];
    [self setSelectedBackgroundView:backgroundView];
}

#pragma mark - Protocol Methods

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    ELMenuItem *menuItem = (ELMenuItem *)object;
    
    // Content
    self.textLabel.text = [menuItem.name uppercaseString];
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {
    // No action since it is handled in the view controller's delegate implementation
}

@end
