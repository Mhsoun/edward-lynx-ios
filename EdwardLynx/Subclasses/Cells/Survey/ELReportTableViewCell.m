//
//  ELReportTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELReportTableViewCell.h"
#import "ELInstantFeedback.h"
#import "ELSurvey.h"

@implementation ELReportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // UI
    self.nextIcon.image = [FontAwesome imageWithIcon:fa_chevron_right
                                           iconColor:ThemeColor(kELOrangeColor)
                                            iconSize:50];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Protocol Methods

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    if ([object isKindOfClass:[ELInstantFeedback class]]) {
        ELInstantFeedback *feedback = (ELInstantFeedback *)object;
        
        [self configureWithDetails:@{@"title": feedback.question.text ? feedback.question.text : @"",
                                     @"detail": [ELUtils labelByAnswerType:feedback.question.answer.type],
                                     @"timestamp": feedback.dateString,
                                     @"type": @"Instant Feedback",
                                     @"color": kELFeedbackColor,
                                     @"invited": [NSString stringWithFormat:@"%@/%@",
                                                  @(feedback.answered),
                                                  @(feedback.invited)]}];
    } else {
        ELSurvey *survey = (ELSurvey *)object;
        
        [self configureWithDetails:@{@"title": survey.name ? survey.name : @"",
                                     @"detail": survey.evaluationText,
                                     @"timestamp": survey.endDateString,
                                     @"type": [ELUtils labelBySurveyType:survey.type],
                                     @"color": kELLynxColor,
                                     @"invited": [NSString stringWithFormat:@"%@/%@",
                                                  @(survey.answered),
                                                  @(survey.invited)]}];
    }
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Private Methods

- (void)configureWithDetails:(NSDictionary *)detailsDict {
    NSString *colorKey = kELWhiteColor;
    
    // Content
    self.titleLabel.text = detailsDict[@"title"];
    self.detailLabel.text = detailsDict[@"detail"];
    self.timestampLabel.text = detailsDict[@"timestamp"];
    self.typeLabel.text = [detailsDict[@"type"] uppercaseString];
    self.invitedLabel.text = detailsDict[@"invited"];
    
    // UI
    self.invitedIcon.image = [FontAwesome imageWithIcon:fa_user
                                              iconColor:ThemeColor(colorKey)
                                               iconSize:50];
    self.invitedLabel.textColor = ThemeColor(colorKey);
    self.timestampLabel.textColor = ThemeColor(kELTextFieldBGColor);
    self.typeLabel.backgroundColor = ThemeColor(detailsDict[@"color"]);
    self.typeLabel.layer.cornerRadius = 2.0f;
}

@end
