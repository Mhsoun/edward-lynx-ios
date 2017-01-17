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

@property (nonatomic, strong) ELFeedbackViewManager *viewManager;

@end

@implementation ELAnswerInstantFeedbackViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.viewManager = [[ELFeedbackViewManager alloc] init];
    self.viewManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (ELFeedbackViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    // TODO Implementation
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    __kindof ELBaseQuestionTypeView *questionView;
    ELQuestion *question = self.feedback.question;
    BOOL toExpand = [ELUtils toggleQuestionTypeViewExpansionByType:question.answer.type];
    
    questionView = [ELUtils viewByAnswerType:question.answer.type];
    questionView.question = question;
    
    // Content
    self.questionLabel.text = question.text;
    
    // UI
    if (!questionView) {
        return;
    }
    
    self.heightConstraint.constant = toExpand ? 185 : 135;
    questionView.frame = self.questionTypeView.frame;
    
    [self.questionTypeView addSubview:questionView];
}

#pragma mark - Interface Builder Actions

- (IBAction)onDoneButtonClick:(id)sender {
    NSDictionary *formDict = @{@"key": self.feedback.key,
                               @"answers": @[[[ELUtils questionViewFromSuperview:self.questionTypeView] formValues]]};
    
    [self.viewManager processInstantFeedbackAnswerSubmissionAtId:self.feedback.objectId
                                                    withFormData:formDict];
}

@end
