//
//  ELInstantFeedbackViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELInstantFeedbackViewController.h"

#pragma mark - Private Constants

static CGFloat const kELCornerRadius = 4.0f;
static NSString * const kELNoQuestionType = @"No type selected";

#pragma mark - Class Extension

@interface ELInstantFeedbackViewController ()

@end

@implementation ELInstantFeedbackViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.questionTypeLabel.text = kELNoQuestionType;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    self.questionTypeButton.layer.cornerRadius = kELCornerRadius;
    self.inviteButton.layer.cornerRadius = kELCornerRadius;
}

#pragma mark - Interface Builder Actions

- (IBAction)onQuestionTypeButtonClick:(id)sender {
    UIAlertController *controller;
    void (^alertActionBlock)(UIAlertAction *) = ^(UIAlertAction *action) {
        self.questionTypeLabel.text = action.title;
    };
    
    controller = [UIAlertController alertControllerWithTitle:@"Select preferred Question type"
                                                     message:nil
                                              preferredStyle:UIAlertControllerStyleActionSheet];
    
    [controller addAction:[UIAlertAction actionWithTitle:kELQuestionTypeOneToFiveScale
                                                   style:UIAlertActionStyleDefault
                                                 handler:alertActionBlock]];
    [controller addAction:[UIAlertAction actionWithTitle:kELQuestionTypeOneToTenScale
                                                   style:UIAlertActionStyleDefault
                                                 handler:alertActionBlock]];
    [controller addAction:[UIAlertAction actionWithTitle:kELQuestionTypeAgreeementScale
                                                   style:UIAlertActionStyleDefault
                                                 handler:alertActionBlock]];
    [controller addAction:[UIAlertAction actionWithTitle:kELQuestionTypeYesNoScale
                                                   style:UIAlertActionStyleDefault
                                                 handler:alertActionBlock]];
    [controller addAction:[UIAlertAction actionWithTitle:kELQuestionTypeStrongAgreeementScale
                                                   style:UIAlertActionStyleDefault
                                                 handler:alertActionBlock]];
    [controller addAction:[UIAlertAction actionWithTitle:kELQuestionTypeText
                                                   style:UIAlertActionStyleDefault
                                                 handler:alertActionBlock]];
    [controller addAction:[UIAlertAction actionWithTitle:kELQuestionTypeInvertedAgreementScale
                                                   style:UIAlertActionStyleDefault
                                                 handler:alertActionBlock]];
    [controller addAction:[UIAlertAction actionWithTitle:kELQuestionTypeOneToTenWithExplanation
                                                   style:UIAlertActionStyleDefault
                                                 handler:alertActionBlock]];
    [controller addAction:[UIAlertAction actionWithTitle:kELQuestionTypeCustomScale
                                                   style:UIAlertActionStyleDefault
                                                 handler:alertActionBlock]];
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
    // TODO Send to API for processing
}

@end
