//
//  ELAddGoalActionTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 07/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAddGoalActionTableViewCell.h"

@implementation ELAddGoalActionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // UI
    self.addActionButton.tintColor = ThemeColor(kELOrangeColor);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Interface Builder Actions

- (IBAction)onAddActionButtonClick:(id)sender {
    [NotificationCenter postNotificationName:kELGoalActionAddNotification
                                      object:nil
                                    userInfo:@{@"index": @(self.tag), @"link": self.addLink}];
}

@end
