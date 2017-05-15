//
//  ELDashboardReminderTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDashboardReminderTableViewCell.h"

#pragma mark - Class Extension

@interface ELDashboardReminderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueLabel;

@end

@implementation ELDashboardReminderTableViewCell

#pragma mark - Lifecycle

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
    self.detailLabel.text = reminder.name;
    self.dueLabel.attributedText = reminder.attributedDueDateInfo;
    
    // UI
    switch (reminder.type) {
        case kELReminderTypeFeedback:
            self.typeLabel.text = [NSLocalizedString(@"kELDashboardReminderFeedback", nil) uppercaseString];
            
            colorKey = kELFeedbackColor;
            
            break;
        case kELReminderTypeGoal:
            self.typeLabel.text = [NSLocalizedString(@"kELDashboardReminderGoal", nil) uppercaseString];
            
            colorKey = kELDevPlanColor;
            
            break;
        default:
            self.typeLabel.text = [NSLocalizedString(@"kELDashboardReminderSurvey", nil) uppercaseString];
            
            colorKey = kELLynxColor;
            
            break;
    }
    
    self.typeLabel.textColor = [[RNThemeManager sharedManager] colorForKey:colorKey];
    self.statusView.backgroundColor = [[RNThemeManager sharedManager] colorForKey:colorKey];
}

@end
