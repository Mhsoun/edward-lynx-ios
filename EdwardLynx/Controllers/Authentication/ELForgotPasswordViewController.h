//
//  ELForgotPasswordViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 13/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <RNThemeManager/RNThemeLabel.h>

#import "ELBaseViewController.h"

@interface ELForgotPasswordViewController : ELBaseViewController<UITextFieldDelegate, ELAPIResponseDelegate>

@property (weak, nonatomic) IBOutlet RNThemeLabel *recoverPasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameEmailTextField;
@property (weak, nonatomic) IBOutlet UIImageView *usernameEmailIcon;
@property (weak, nonatomic) IBOutlet UILabel *usernameEmailErrorLabel;
@property (weak, nonatomic) IBOutlet UIButton *recoverButton;
- (IBAction)onRecoverButtonClick:(id)sender;
- (IBAction)onBackButtonClick:(id)sender;

@end
