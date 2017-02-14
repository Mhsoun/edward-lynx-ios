//
//  ELCreateInstantFeedbackViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"

@interface ELCreateInstantFeedbackViewController : ELBaseViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ELItemCellDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *radioGroupView;
@property (weak, nonatomic) IBOutlet UILabel *questionTypeErrorLabel;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UILabel *questionErrorLabel;
@property (weak, nonatomic) IBOutlet UISwitch *isAnonymousSwitch;
@property (weak, nonatomic) IBOutlet UILabel *isNALabel;
@property (weak, nonatomic) IBOutlet UISwitch *isNASwitch;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

- (IBAction)onInviteButtonClick:(id)sender;

@end
