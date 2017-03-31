//
//  ELSurveyTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveyTableViewCell.h"
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
    ELSurvey *survey = (ELSurvey *)object;
    NSString *status = [[ELUtils labelBySurveyStatus:survey.status] uppercaseString];
    NSString *colorString = survey.status == kELSurveyStatusCompleted ? kELGreenColor : kELDarkGrayColor;
    
    self.survey = survey;
    
    // Content
    self.surveyLabel.text = survey.name;
    self.typeLabel.text = [[ELUtils labelBySurveyType:survey.type] uppercaseString];
    self.descriptionLabel.text = survey.evaluationText;
    self.statusLabel.text = status;
    
    // UI
    self.monthLabel.text = [[NSDate mt_shortMonthlySymbols][survey.endDate.mt_monthOfYear - 1] uppercaseString];
    self.dayLabel.text = [[NSNumber numberWithInteger:survey.endDate.mt_dayOfYear] stringValue];
    self.yearLabel.text = [[NSNumber numberWithInteger:survey.endDate.mt_year] stringValue];
    
    [self toggleCalendarState];
    
    self.statusLabel.layer.cornerRadius = 2.0f;
    self.statusLabel.backgroundColor = [[RNThemeManager sharedManager] colorForKey:colorString];
    self.reactivateLabel.hidden = ![survey.endDate mt_isBefore:[NSDate date]];
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {
    //
}

#pragma mark - Private Methods

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
