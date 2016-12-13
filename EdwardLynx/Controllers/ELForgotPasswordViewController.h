//
//  ELForgotPasswordViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 13/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"

@interface ELForgotPasswordViewController : ELBaseViewController

@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *recoverButton;
- (IBAction)onBackButtonClick:(id)sender;

@end
