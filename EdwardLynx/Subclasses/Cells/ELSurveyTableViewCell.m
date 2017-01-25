//
//  ELSurveyTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveyTableViewCell.h"

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
    
    // Content
    self.surveyLabel.text = survey.name;
    self.descriptionLabel.text = survey.shortDescription;
    self.expiryLabel.text = [[ELAppSingleton sharedInstance].dateFormatter stringFromDate:survey.endDate];
    self.statusLabel.text = [NSString stringWithFormat:@"  %@  ", status];
    
    // UI
    self.statusLabel.layer.cornerRadius = 2.0f;
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {
    //
}

@end
