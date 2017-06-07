//
//  ELGoalActionTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 24/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELGoalActionTableViewCell.h"

@implementation ELGoalActionTableViewCell

- (void)awakeFromNib {
    CGFloat iconSize;
    
    [super awakeFromNib];
    // Initialization code
    
    // UI
    iconSize = kELIconSize;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self.moreButton setImage:[FontAwesome imageWithIcon:fa_ellipsis_vertical
                                               iconColor:[UIColor whiteColor]
                                                iconSize:iconSize
                                               imageSize:CGSizeMake(iconSize, iconSize)]
                     forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imageView;
    ELGoalAction *action = (ELGoalAction *)object;
    UIImage *checkIcon = [FontAwesome imageWithIcon:action.checked ? fa_check_circle : fa_circle_o
                                          iconColor:action.checked ? ThemeColor(kELGreenColor) : [UIColor whiteColor]
                                           iconSize:kELIconSize
                                          imageSize:CGSizeMake(kELIconSize, kELIconSize)];
    
    imageView = [[UIImageView alloc] initWithFrame:self.statusView.bounds];
    imageView.image = checkIcon;
    
    [self.statusView addSubview:imageView];
    [self.titleLabel setText:action.title];
}

- (void)updateStatusView:(__kindof UIView *)statusView {
    for (__kindof UIView *subview in self.statusView.subviews) {
        [subview removeFromSuperview];
    }
    
    [self.statusView addSubview:statusView];
}

#pragma mark - Interface Builder Actions

- (IBAction)onMoreButtonClick:(id)sender {
    
}

@end
