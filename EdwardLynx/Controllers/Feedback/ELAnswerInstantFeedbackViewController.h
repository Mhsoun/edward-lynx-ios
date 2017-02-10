//
//  ELAnswerInstantFeedbackViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseQuestionTypeView.h"
#import "ELBaseDetailViewController.h"
#import "ELDetailViewManager.h"
#import "ELFeedbackViewManager.h"
#import "ELInstantFeedback.h"
#import "ELQuestion.h"
#import "ELSurveysAPIClient.h"

@interface ELAnswerInstantFeedbackViewController : ELBaseDetailViewController<ELAPIPostResponseDelegate, ELAPIResponseDelegate>

@property (nonatomic, strong) ELInstantFeedback *instantFeedback;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIView *questionTypeView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
- (IBAction)onSubmitButtonClick:(id)sender;

@end
