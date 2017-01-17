//
//  ELQuestionTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestionTableViewCell.h"

@implementation ELQuestionTableViewCell

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
    __kindof ELBaseQuestionTypeView *questionView;
    ELQuestion *question = (ELQuestion *)object;
    BOOL toExpand = [ELUtils toggleQuestionTypeViewExpansionByType:question.answer.type];
    
    questionView = [ELUtils viewByAnswerType:question.answer.type];
    questionView.question = question;
    
    // Content
    self.questionLabel.text = question.text;
    
    // UI
    if (!questionView) {
        return;
    }
    
    self.questionContainerHeightConstraint.constant = toExpand ? kELQuestionTypeExpandedHeight : kELQuestionTypeDefaultHeight;
    questionView.frame = self.questionContainerView.frame;
    
    [self.questionContainerView addSubview:questionView];
}

@end
