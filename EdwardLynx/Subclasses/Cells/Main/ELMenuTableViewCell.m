//
//  ELMenuTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 19/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELMenuTableViewCell.h"
#import "ELMenuItem.h"

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
    
    [backgroundView setBackgroundColor:[[RNThemeManager sharedManager] colorForKey:kELDarkVioletColor]];
    [self setSelectedBackgroundView:backgroundView];
}

#pragma mark - Protocol Methods

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    CGFloat iconHeight = 20;
    ELMenuItem *menuItem = (ELMenuItem *)object;
    
    // Content
    self.textLabel.text = menuItem.name;
    self.imageView.image = [FontAwesome imageWithIcon:menuItem.iconIdentifier
                                            iconColor:[[RNThemeManager sharedManager] colorForKey:kELVioletColor]
                                             iconSize:iconHeight
                                            imageSize:CGSizeMake(iconHeight, iconHeight)];
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {

}

@end
