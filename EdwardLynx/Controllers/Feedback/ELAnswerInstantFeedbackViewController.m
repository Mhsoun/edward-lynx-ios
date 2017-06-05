//
//  ELAnswerInstantFeedbackViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAnswerInstantFeedbackViewController.h"
#import "ELBaseQuestionTypeView.h"
#import "ELDetailViewManager.h"
#import "ELFeedbackViewManager.h"
#import "ELInstantFeedback.h"
#import "ELQuestion.h"
#import "ELSurveysAPIClient.h"

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
        self.submitButton.hidden = YES;
        
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

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Protocol Methods (ELDetailViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [self.indicatorView stopAnimating];
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDetailsPageLoadError", nil)
                     completion:nil];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    self.instantFeedback = [[ELInstantFeedback alloc] initWithDictionary:responseDict error:nil];
    
    [self.submitButton setHidden:NO];
    [self.indicatorView stopAnimating];
    [self populatePage];
}

#pragma mark - Protocol Methods (ELFeedbackViewManager)

- (void)onAPIPostResponseError:(NSDictionary *)errorDict {
    __weak typeof(self) weakSelf = self;
    
    [self dismissViewControllerAnimated:YES completion:^{
        [ELUtils presentToastAtView:weakSelf.view
                            message:NSLocalizedString(@"kELFeedbackAnswerError", nil)
                         completion:nil];
    }];
}

- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict {
    __weak typeof(self) weakSelf = self;
    
    AppSingleton.needsPageReload = YES;
    
    [self dismissViewControllerAnimated:YES completion:^{
        // Back to the Feedbacks list
        [ELUtils presentToastAtView:weakSelf.view
                            message:NSLocalizedString(@"kELFeedbackAnswerSuccess", nil)
                         completion:^{
                             [weakSelf.navigationController popViewControllerAnimated:YES];
                         }];
    }];
}

#pragma mark - Private Methods

- (void)populatePage {
    BOOL toExpand;
    CGFloat height;
    ELQuestion *question = self.instantFeedback.question;
    __kindof ELBaseQuestionTypeView *questionView = [ELUtils viewByAnswerType:question.answer.type];
    
    toExpand = question.answer.type != kELAnswerTypeText;
    height = toExpand ? (question.answer.options.count * kELCustomScaleItemHeight) + kELCustomScaleItemHeight : 135;
    
    // Content
    self.questionLabel.text = question.text;
    self.anonymousLabel.text = self.instantFeedback.anonymous ? NSLocalizedString(@"kELFeedbackAnonymousLabel", nil) : @"";
    
    // UI
    if (!questionView) {
        return;
    }
    
    questionView.question = question;
    questionView.frame = self.questionTypeView.bounds;
    
    [self.heightConstraint setConstant:height];
    [self.questionTypeView updateConstraints];
    [self.questionTypeView addSubview:questionView];
}

#pragma mark - Interface Builder Actions

- (IBAction)onSubmitButtonClick:(id)sender {
    NSDictionary *formDict = [[ELUtils questionViewFromSuperview:self.questionTypeView] formValues];
    
    if (!formDict) {
        [ELUtils presentToastAtView:self.view
                            message:NSLocalizedString(@"kELFeedbackAnswerRequired", nil)
                         completion:nil];
        
        return;
    }
    
    if (!self.instantFeedback.key) {
        [ELUtils presentToastAtView:self.view
                            message:NSLocalizedString(@"kELFeedbackUnauthorizedLabel", nil)
                         completion:nil];
        
        return;
    }
    
    // Loading alert
    [self presentViewController:[ELUtils loadingAlert]
                       animated:YES
                     completion:nil];
    [self.feedbackViewManager processInstantFeedbackAnswerSubmissionWithId:self.instantFeedback.objectId
                                                                  formData:@{@"key": self.instantFeedback.key,
                                                                             @"answers": @[formDict]}];
}

@end
