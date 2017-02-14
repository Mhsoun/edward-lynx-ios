//
//  ELEditProfileViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"

@interface ELEditProfileViewController : ELBaseViewController<UITextFieldDelegate, ELAPIResponseDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameErrorLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIView *radioGroupView;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UITextField *roleTextField;
@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)onSaveButtonClick:(id)sender;

@end
