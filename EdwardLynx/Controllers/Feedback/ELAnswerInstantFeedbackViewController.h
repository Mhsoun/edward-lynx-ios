//
//  ELAnswerInstantFeedbackViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseDetailViewController.h"

@class ELInstantFeedback;

@interface ELAnswerInstantFeedbackViewController : ELBaseDetailViewController<ELAPIPostResponseDelegate, ELAPIResponseDelegate>

@property (nonatomic, strong) ELInstantFeedback *instantFeedback;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *anonymousLabel;
@property (weak, nonatomic) IBOutlet UIView *questionTypeView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *sendAnonymousLabel;
@property (weak, nonatomic) IBOutlet UISwitch *anonymousSwitch;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)onSubmitButtonClick:(id)sender;

@end
