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
    BOOL toExpand;
    __kindof ELBaseQuestionTypeView *questionView;
    ELQuestion *question = (ELQuestion *)object;
    NSArray *answerTypes = @[@(kELAnswerTypeOneToTenWithExplanation), @(kELAnswerTypeText),
                             @(kELAnswerTypeAgreeementScale), @(kELAnswerTypeStrongAgreeementScale),
                             @(kELAnswerTypeInvertedAgreementScale)];
    
    toExpand = [answerTypes containsObject:@(question.answer.type)];
    questionView = [ELUtils viewByAnswerType:question.answer.type];
    questionView.question = question;
    
    // Content
    self.questionLabel.text = question.text;
    
    // UI
    if (!questionView) {
        return;
    }
    
    self.questionContainerHeightConstraint.constant = toExpand ? 90 : 40;
    questionView.frame = self.questionContainerView.frame;
    
    [self.questionContainerView addSubview:questionView];
}

#pragma mark - Public Methods

- (__kindof ELBaseQuestionTypeView *)questionView {
    for (__kindof UIView *view in self.questionContainerView.subviews) {
        if ([view isKindOfClass:[ELBaseQuestionTypeView class]]) {
            return view;
        }
    }
    
    return nil;
}

@end
