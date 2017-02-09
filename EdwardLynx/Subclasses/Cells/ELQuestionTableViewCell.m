//
//  ELQuestionTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestionTableViewCell.h"

#pragma mark - Class Extension

@interface ELQuestionTableViewCell ()

@property (nonatomic, strong) NSString *helpText;

@end

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
    CGFloat toExpandHeight = question.answer.type == kELAnswerTypeOneToTenWithExplanation ? 110 : kELQuestionTypeExpandedHeight;
    
    questionView = [ELUtils viewByAnswerType:question.answer.type];
    questionView.question = question;
    
    // Content
    self.questionLabel.text = question.text;
    self.helpText = question.answer.help;
    
    // UI
    if (!questionView) {
        return;
    }
    
    // Check if subview as already been added
    if (![self hasQuestionViewAsSubview]) {
        self.questionContainerHeightConstraint.constant = toExpand ? toExpandHeight : kELQuestionTypeDefaultHeight;
        questionView.frame = self.questionContainerView.frame;
        
        [self.questionContainerView addSubview:questionView];
    }
}

#pragma mark - Private Methods

- (BOOL)hasQuestionViewAsSubview {
    for (UIView *subview in self.questionContainerView.subviews) {
        if ([subview isKindOfClass:[ELBaseQuestionTypeView class]]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Interface Builder Actions

- (IBAction)onPopupHelpButtonClick:(id)sender {
    // TODO Display help text
}

@end
