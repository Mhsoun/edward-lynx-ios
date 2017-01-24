//
//  ELChangePassViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAccountsViewManager.h"
#import "ELBaseViewController.h"

@interface ELChangePassViewController : ELBaseViewController<UITextFieldDelegate, ELAPIResponseDelegate>

@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *currentPasswordErrorLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *passwordErrorLabel;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *confirmPasswordErrorLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)onSaveButtonClick:(id)sender;

@end
