//
//  ELRespondentFreeTextTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/02/2018.
//  Copyright © 2018 Ingenuity Global Consulting. All rights reserved.
//

#import "ELRespondentFreeTextTableViewCell.h"
#import "ELAnswerOption.h"

@implementation ELRespondentFreeTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    ELAnswerOption *option = (ELAnswerOption *)object;
    ELAnswerOptionRespondent *respondent = [option.submissions firstObject];
    
    self.responseLabel.text = (NSString *)option.value;
    self.respondentLabel.text = respondent ? respondent.name : @"Anonymous";
}

@end
