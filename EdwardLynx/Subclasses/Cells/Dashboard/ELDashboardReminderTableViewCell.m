//
//  ELDashboardReminderTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDashboardReminderTableViewCell.h"

@interface ELDashboardReminderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *statusView;
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

#pragma mark - Protocol Methods

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    NSString *colorKey;
    ELReminder *reminder = (ELReminder *)object;
    
    // Content
    self.typeLabel.text = [reminder.name uppercaseString];
    self.detailLabel.text = reminder.shortDescription;
    self.dueLabel.attributedText = reminder.attributedDueDateInfo;
    
    // UI
    switch (reminder.type) {
        case kELReminderTypeGoal:
            colorKey = kELDevPlanColor;
            
            break;
        case kELReminderTypeFeedback:
            colorKey = kELFeedbackColor;
            
            break;
        default:
            colorKey = kELOrangeColor;
            
            break;
    }
    
    self.typeLabel.textColor = [[RNThemeManager sharedManager] colorForKey:colorKey];
    self.statusView.backgroundColor = [[RNThemeManager sharedManager] colorForKey:colorKey];
}

@end
