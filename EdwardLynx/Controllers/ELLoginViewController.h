//
//  ELLoginViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAPIClient.h"
#import "ELAccountsViewManager.h"
#import "ELBaseViewController.h"

@interface ELLoginViewController : ELBaseViewController<ELAPIResponseDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *usernameIcon;
@property (weak, nonatomic) IBOutlet UILabel *usernameErrorLabel;

@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIcon;
@property (weak, nonatomic) IBOutlet UILabel *passwordErrorLabel;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)onLoginButtonClick:(id)sender;

@end
