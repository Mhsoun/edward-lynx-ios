//
//  ELDashboardReminderTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDashboardReminderTableViewCell.h"

@interface ELDashboardReminderTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueLabel;

@end

@implementation ELDashboardReminderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
