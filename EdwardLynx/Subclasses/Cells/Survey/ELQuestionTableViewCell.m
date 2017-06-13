//
//  ELQuestionTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestionTableViewCell.h"
#import "ELBaseQuestionTypeView.h"
#import "ELQuestion.h"
#import "ELQuestionTypeRadioGroupView.h"

#pragma mark - Class Extension

@interface ELQuestionTableViewCell ()

@property (nonatomic, strong) NSString *helpText;

@end

@implementation ELQuestionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CGFloat iconSize = 15;
    
    [self.popupHelpButton setImage:[FontAwesome imageWithIcon:fa_info_circle
                                                    iconColor:[UIColor whiteColor]
                                                     iconSize:iconSize
                                                    imageSize:CGSizeMake(iconSize, iconSize)]
                          forState:UIControlStateNormal];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    // Clear question view
    [self.questionContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Protocol Methods

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    __kindof ELBaseQuestionTypeView *questionView;
    ELQuestion *question = (ELQuestion *)object;
    
    questionView = [ELUtils viewByAnswerType:question.answer.type];
    
    // Content
    self.questionLabel.text = question.text;
    self.helpText = question.answer.help;
    
    // Check if subview has already been added
    if (!questionView || [self hasQuestionViewAsSubview:[questionView class]]) {
        return;
    }
    
    questionView.frame = self.questionContainerView.bounds;
    questionView.question = question;
    
    [self.questionContainerHeightConstraint setConstant:question.heightForQuestionView];
    [self.questionContainerView addSubview:questionView];
}

#pragma mark - Private Methods

- (BOOL)hasQuestionViewAsSubview:(Class)class {
    for (UIView *subview in self.questionContainerView.subviews) {
        if ([subview isKindOfClass:class]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Interface Builder Actions

- (IBAction)onPopupHelpButtonClick:(id)sender {
    [self makeToast:self.helpText
           duration:99999
           position:CSToastPositionCenter];
}

@end
