//
//  ELInstantFeedbackViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELInstantFeedbackViewController.h"

#pragma mark - Private Constants

static NSString * const kELNoQuestionType = @"No type selected";

#pragma mark - Class Extension

@interface ELInstantFeedbackViewController ()

@property (nonatomic, strong) NSDictionary *instantFeedbackDict;
@property (nonatomic, strong) ELFeedbackViewManager *viewManager;

@end

@implementation ELInstantFeedbackViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.viewManager = [[ELFeedbackViewManager alloc] init];
    self.questionTypeLabel.text = kELNoQuestionType;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"InviteFeedbackParticipants"]) {
        ELInviteUsersViewController *controller = [segue destinationViewController];
        controller.instantFeedbackDict = self.instantFeedbackDict;
    }
}

#pragma mark - Interface Builder Actions

- (IBAction)onQuestionTypeButtonClick:(id)sender {
    UIAlertController *controller;
    NSArray *answerTypes = @[@(kELAnswerTypeOneToFiveScale), @(kELAnswerTypeOneToTenScale), @(kELAnswerTypeAgreeementScale),
                             @(kELAnswerTypeYesNoScale), @(kELAnswerTypeStrongAgreeementScale), @(kELAnswerTypeText),
                             @(kELAnswerTypeInvertedAgreementScale), @(kELAnswerTypeOneToTenWithExplanation), @(kELAnswerTypeCustomScale)];
    void (^alertActionBlock)(UIAlertAction *) = ^(UIAlertAction *action) {
        self.questionTypeLabel.text = action.title;
    };
    
    controller = [UIAlertController alertControllerWithTitle:@"Select preferred Question type"
                                                     message:nil
                                              preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSNumber *answerTypeObj in answerTypes) {
        kELAnswerType answerType = [answerTypeObj integerValue];
        
        [controller addAction:[UIAlertAction actionWithTitle:[ELUtils labelByAnswerType:answerType]
                                                       style:UIAlertActionStyleDefault
                                                     handler:alertActionBlock]];
    }
    
    [controller addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    
    if (IDIOM == IPAD) {
        UIPopoverPresentationController *popPresenter;
        
        [controller setModalPresentationStyle:UIModalPresentationPopover];
        
        popPresenter = [controller popoverPresentationController];
        popPresenter.sourceView = (UIButton *)sender;
        popPresenter.sourceRect = [(UIButton *)sender bounds];
    }
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)onInviteButtonClick:(id)sender {
    BOOL isValid;
    ELFormItemGroup *typeGroup, *questionGroup;
    
    typeGroup = [[ELFormItemGroup alloc] initWithText:self.questionTypeLabel.text
                                                 icon:nil
                                           errorLabel:self.questionTypeErrorLabel];
    questionGroup = [[ELFormItemGroup alloc] initWithText:self.questionTextView.text
                                                     icon:nil
                                               errorLabel:self.questionErrorLabel];
    self.instantFeedbackDict = @{@"type": typeGroup, @"question": questionGroup};
    isValid = [self.viewManager validateCreateInstantFeedbackFormValues:self.instantFeedbackDict];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (!isValid) {
        return;
    }
    
    [self performSegueWithIdentifier:@"InviteFeedbackParticipants" sender:self];
}

@end
