//
//  ELInstantFeedbackViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELFeedbackViewManager.h"
#import "ELInviteUsersViewController.h"

@interface ELInstantFeedbackViewController : ELBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *questionTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *questionTypeButton;
@property (weak, nonatomic) IBOutlet UILabel *questionTypeErrorLabel;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UILabel *questionErrorLabel;
@property (weak, nonatomic) IBOutlet UISwitch *isAnonymousSwitch;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
- (IBAction)onQuestionTypeButtonClick:(id)sender;
- (IBAction)onInviteButtonClick:(id)sender;

@end
