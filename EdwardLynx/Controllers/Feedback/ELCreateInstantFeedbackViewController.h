//
//  ELCreateInstantFeedbackViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"

@class ELInstantFeedback;

@interface ELCreateInstantFeedbackViewController : ELBaseViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, ELDropdownDelegate, ELItemCellDelegate>

@property (strong, nonatomic) ELInstantFeedback *instantFeedback;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *dropdownView;
@property (weak, nonatomic) IBOutlet UIView *formView;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UILabel *questionErrorLabel;
@property (weak, nonatomic) IBOutlet UISwitch *isAnonymousSwitch;
@property (weak, nonatomic) IBOutlet UILabel *isNALabel;
@property (weak, nonatomic) IBOutlet UISwitch *isNASwitch;
@property (weak, nonatomic) IBOutlet UIView *questionContainerView;
@property (weak, nonatomic) IBOutlet UIView *questionPreview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *questionPreviewLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

- (IBAction)onNAOptionSwitchValueChange:(id)sender;
- (IBAction)onInviteButtonClick:(id)sender;

@end
