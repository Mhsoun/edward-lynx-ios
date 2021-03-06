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
    self.navigationItem.title = [self.navigationItem.title uppercaseString];
    
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Clear answers
    AppSingleton.mSurveyFormDict = [[NSMutableDictionary alloc] init];
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
    
    // Decrement badge count
    Application.applicationIconBadgeNumber--;
}

#pragma mark - Protocol Methods (ELFeedbackViewManager)

- (void)onAPIPostResponseError:(NSDictionary *)errorDict {
//    __weak typeof(self) weakSelf = self;
    
    [self dismissViewControllerAnimated:YES completion:^{
//        [ELUtils presentToastAtView:weakSelf.view
//                            message:NSLocalizedString(@"kELFeedbackAnswerError", nil)
//                         completion:nil];
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
    
    toExpand = question.answer.type == kELAnswerTypeCustomScale;
    height = toExpand ? (question.answer.options.count * kELCustomScaleItemHeight) + kELCustomScaleItemHeight : 135;
    
    // Content
    NSString *senderText = [NSString stringWithFormat:NSLocalizedString(@"kELFeedbackSenderLabel", nil), self.instantFeedback.senderName];
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] initWithString:senderText];
    
    [mString addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"Lato-Bold" size:18]
                    range:[senderText rangeOfString:self.instantFeedback.senderName]];
    
    self.senderLabel.attributedText = [mString copy];
    self.questionLabel.text = question.text;
    self.anonymousLabel.text = self.instantFeedback.anonymous ? NSLocalizedString(@"kELFeedbackAnonymousLabel", nil) : @"";
    
    // UI
    self.anonymousSwitch.hidden = NO;
    self.sendAnonymousLabel.hidden = NO;
    self.sendAnonymousLabel.text = NSLocalizedString(@"kELFeedbacksSendAsAnonymousLabel", nil);
    
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
    
    NSDictionary *params = @{@"key": self.instantFeedback.key,
                             @"anonymous": @(self.anonymousSwitch.isOn),
                             @"answers": @[formDict]};
    
    [self.feedbackViewManager processInstantFeedbackAnswerSubmissionWithId:self.instantFeedback.objectId
                                                                  formData:params];
}

@end
