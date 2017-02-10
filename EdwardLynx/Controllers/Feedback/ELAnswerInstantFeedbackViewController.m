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

@property (nonatomic, strong) ELDetailViewManager *detailViewManager;
@property (nonatomic, strong) ELFeedbackViewManager *feedbackViewManager;

@end

@implementation ELAnswerInstantFeedbackViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    if (!self.instantFeedback) {
        self.detailViewManager = [[ELDetailViewManager alloc] initWithObjectId:self.objectId];
        
        [self.detailViewManager processRetrievalOfInstantFeedbackDetails];
    } else {
        self.detailViewManager = [[ELDetailViewManager alloc] initWithDetailObject:self.instantFeedback];
        
        [self.indicatorView stopAnimating];
        [self populatePage];
    }
    
    self.feedbackViewManager = [[ELFeedbackViewManager alloc] init];
    self.feedbackViewManager.delegate = self;
    self.detailViewManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (ELDetailViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDetailsPageLoadError", nil)
                     completion:^{}];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    self.instantFeedback = [[ELInstantFeedback alloc] initWithDictionary:responseDict error:nil];
    
    [self.indicatorView stopAnimating];
    [self populatePage];
}

#pragma mark - Protocol Methods (ELFeedbackViewManager)

- (void)onAPIPostResponseError:(NSDictionary *)errorDict {
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELFeedbackAnswerError", nil)
                     completion:^{}];
}

- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods

- (void)populatePage {
    ELQuestion *question = self.instantFeedback.question;
    BOOL toExpand = [ELUtils toggleQuestionTypeViewExpansionByType:question.answer.type];
    __kindof ELBaseQuestionTypeView *questionView = [ELUtils viewByAnswerType:question.answer.type];
    
    // Content
    self.questionLabel.text = question.text;
    
    // UI
    if (!questionView) {
        return;
    }
    
    questionView.question = question;
    questionView.frame = self.questionTypeView.frame;
    
    [self.heightConstraint setConstant:toExpand ? 185 : 135];
    [self.questionTypeView updateConstraints];
    [self.questionTypeView addSubview:questionView];
}

#pragma mark - Interface Builder Actions

- (IBAction)onSubmitButtonClick:(id)sender {
    NSDictionary *formDict = @{@"key": self.instantFeedback.key,
                               @"answers": @[[[ELUtils questionViewFromSuperview:self.questionTypeView] formValues]]};
    
    [self.feedbackViewManager processInstantFeedbackAnswerSubmissionAtId:self.instantFeedback.objectId
                                                            withFormData:formDict];
}

@end
