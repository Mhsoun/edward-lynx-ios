//
//  ELInviteUsersViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELFeedbackViewManager.h"

@interface ELInviteUsersViewController : ELBaseViewController

@property (strong, nonatomic) NSDictionary *instantFeedbackDict;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameErrorLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleErrorLabel;
- (IBAction)onRoleButtonClick:(id)sender;
- (IBAction)onAddButtonClick:(id)sender;

@end
