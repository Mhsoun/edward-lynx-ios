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

@interface ELSurveyTableViewCell ()

@property (nonatomic, strong) ELSurvey *survey;

@end

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
                                     @"status": [ELUtils labelBySurveyStatus:survey.status],
                                     @"date": survey.endDate}];
        
        self.reactivateLabel.hidden = ![survey.endDate mt_isBefore:[NSDate date]];
        self.statusLabel.backgroundColor = [[RNThemeManager sharedManager] colorForKey:colorString];
    } else {
        ELInstantFeedback *feedback = (ELInstantFeedback *)object;
        kELSurveyStatus status = feedback.noOfParticipantsAnswered == 0 ? kELSurveyStatusOpen :
                                                                          kELSurveyStatusPartial;
        
        [self configureWithDetails:@{@"title": feedback.question.text,
                                     @"type": @"Instant Feedback",
                                     @"description": @"",
                                     @"status": [ELUtils labelBySurveyStatus:status],
                                     @"date": feedback.createdAt}];
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
    self.statusLabel.text = [detailsDict[@"status"] uppercaseString];
    
    // UI
    self.monthLabel.text = [[NSDate mt_shortMonthlySymbols][date.mt_monthOfYear - 1] uppercaseString];
    self.dayLabel.text = [[NSNumber numberWithInteger:date.mt_dayOfYear] stringValue];
    self.yearLabel.text = [[NSNumber numberWithInteger:date.mt_year] stringValue];
    
    self.reactivateLabel.hidden = YES;
    self.statusLabel.layer.cornerRadius = 2.0f;
    self.statusLabel.backgroundColor = [[RNThemeManager sharedManager] colorForKey:kELDarkGrayColor];
    
    [self toggleCalendarState];
}

- (void)toggleCalendarState {
    NSString *colorString;
    
    if (self.survey.status == kELSurveyStatusCompleted) {
        colorString = kELGreenColor;
    } else if ([[NSDate date] mt_weekOfYear] - [self.survey.endDate mt_weekOfYear] <= 2) {
        colorString = kELRedColor;
    } else if ([self.survey.endDate mt_isOnOrBefore:[NSDate date]]) {
        colorString = kELDarkGrayColor;
    } else {
        colorString = kELOrangeColor;
    }
    
    self.monthLabel.backgroundColor = [[RNThemeManager sharedManager] colorForKey:colorString];
}

@end
