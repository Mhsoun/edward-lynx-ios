//
//  ELCreateInstantFeedbackViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAddScaleOptionTableViewCell.h"
#import "ELBaseViewController.h"
#import "ELFeedbackViewManager.h"
#import "ELInviteUsersViewController.h"
#import "ELScaleOptionTableViewCell.h"

@interface ELCreateInstantFeedbackViewController : ELBaseViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ELScaleOptionCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *questionTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *questionTypeButton;
@property (weak, nonatomic) IBOutlet UILabel *questionTypeErrorLabel;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UILabel *questionErrorLabel;
@property (weak, nonatomic) IBOutlet UISwitch *isAnonymousSwitch;
@property (weak, nonatomic) IBOutlet UILabel *isNALabel;
@property (weak, nonatomic) IBOutlet UISwitch *isNASwitch;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)onQuestionTypeButtonClick:(id)sender;
- (IBAction)onInviteButtonClick:(id)sender;

@end
