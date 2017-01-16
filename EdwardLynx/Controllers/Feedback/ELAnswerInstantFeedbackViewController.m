//
//  ELAnswerInstantFeedbackViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAnswerInstantFeedbackViewController.h"

#pragma mark - Private Constants

@interface ELAnswerInstantFeedbackViewController ()

@end

@implementation ELAnswerInstantFeedbackViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    CGRect frame;
    __kindof ELBaseQuestionTypeView *questionView;
    ELQuestion *question = self.feedback.questions[0];
    
    // Answer Type
    frame = self.questionTypeView.frame;
    frame.size.height = [ELUtils toggleQuestionTypeViewExpansionByType:question.answer.type];
    
    self.questionLabel.text = question.text;
    
    questionView = [ELUtils viewByAnswerType:question.answer.type];
    questionView.frame = frame;
    questionView.question = question;
    
    [self.questionTypeView addSubview:questionView];
}

@end
