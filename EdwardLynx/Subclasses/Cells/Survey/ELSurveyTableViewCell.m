//
//  ELSurveyTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveyTableViewCell.h"
#import "ELInstantFeedback.h"
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
    if ([object isKindOfClass:[ELSurvey class]]) {
        ELSurvey *survey = (ELSurvey *)object;
        NSString *colorString = survey.status == kELSurveyStatusCompleted ? kELGreenColor : kELDarkGrayColor;
        
        [self configureWithDetails:@{@"title": survey.name,
                                     @"type": [ELUtils labelBySurveyType:survey.type],
                                     @"description": survey.evaluationText,
                                     @"status": @(survey.status),
                                     @"date": survey.endDate}];
        
        self.reactivateLabel.hidden = ![[NSDate date] mt_isAfter:survey.endDate];
        self.statusLabel.backgroundColor = [[RNThemeManager sharedManager] colorForKey:colorString];
    } else {
        kELSurveyStatus status;
        ELInstantFeedback *feedback = (ELInstantFeedback *)object;
        
        status = feedback.answered == 0 ? kELSurveyStatusOpen : kELSurveyStatusUnfinished;
        
        [self configureWithDetails:@{@"title": feedback.question.text,
                                     @"type": NSLocalizedString(@"kELInstantFeedbackTitle", nil),
                                     @"description": feedback.createdBy,
                                     @"status": @(status),
                                     @"date": feedback.createdAt}];
        
        self.monthLabel.backgroundColor = [[RNThemeManager sharedManager] colorForKey:kELOrangeColor];
    }
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {
    //
}

#pragma mark - Private Methods

- (void)configureWithDetails:(NSDictionary *)detailsDict {
    NSDate *date = detailsDict[@"date"];
    
    // Content
    self.surveyLabel.text = detailsDict[@"title"];
    self.typeLabel.text = [detailsDict[@"type"] uppercaseString];
    self.descriptionLabel.text = detailsDict[@"description"];
    self.statusLabel.text = [[ELUtils labelBySurveyStatus:[detailsDict[@"status"] integerValue]] uppercaseString];
    
    // UI
    self.monthLabel.text = [[NSDate mt_shortMonthlySymbols][date.mt_monthOfYear - 1] uppercaseString];
    self.dayLabel.text = [[NSNumber numberWithInteger:date.mt_dayOfMonth] stringValue];
    self.yearLabel.text = [[NSNumber numberWithInteger:date.mt_year] stringValue];
    
    self.reactivateLabel.hidden = YES;
    self.statusLabel.backgroundColor = [[RNThemeManager sharedManager] colorForKey:kELDarkGrayColor];
    self.statusLabel.layer.cornerRadius = 2.0f;
    
    [self toggleCalendarStateForEndDate:date status:[detailsDict[@"status"] integerValue]];
}

- (void)toggleCalendarStateForEndDate:(NSDate *)endDate status:(kELSurveyStatus)status {
    BOOL beforeExpiration;
    NSString *colorString;
    NSDate *currentDate = [NSDate date];
    
    beforeExpiration = [currentDate mt_isOnOrBefore:endDate];
        
    if (status == kELSurveyStatusCompleted) {
        colorString = kELGreenColor;
    } else if (beforeExpiration &&
               [currentDate mt_daysUntilDate:endDate] <= 14 &&
               status != kELSurveyStatusNotInvited) {
        colorString = kELRedColor;
    } else if (!beforeExpiration) {
        colorString = kELDarkGrayColor;
    } else {
        colorString = kELOrangeColor;
    }
    
    self.monthLabel.backgroundColor = [[RNThemeManager sharedManager] colorForKey:colorString];
}

@end
