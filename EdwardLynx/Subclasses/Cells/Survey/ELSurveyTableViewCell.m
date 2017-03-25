//
//  ELSurveyTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveyTableViewCell.h"
#import "ELSurvey.h"

@implementation ELSurveyTableViewCell

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
    ELSurvey *survey = (ELSurvey *)object;
    NSString *status = [[ELUtils labelBySurveyStatus:survey.status] uppercaseString];
    NSString *dateString = [AppSingleton.printDateFormatter stringFromDate:survey.endDate];
    NSString *colorString = survey.status == kELSurveyStatusCompleted ? kELGreenColor : kELDarkGrayColor;
    
    // Content
    self.surveyLabel.text = survey.name;
    self.descriptionLabel.text = survey.evaluationText;
    self.expiryLabel.text = [NSString stringWithFormat:NSLocalizedString(@"kELExpiresOnLabel", nil), dateString];
    self.statusLabel.text = [NSString stringWithFormat:@"  %@  ", status];
    
    // UI
    self.statusLabel.layer.cornerRadius = 2.0f;
    self.statusLabel.backgroundColor = [[RNThemeManager sharedManager] colorForKey:colorString];
    
    [self.reactivateLabelWidthConstraint setConstant:[survey.endDate mt_isBefore:[NSDate date]] ? 100 : 0];
    [self updateConstraints];
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {
    //
}

@end
