//
//  ELChangePassViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELChangePassViewController.h"

#pragma mark - Class Extension

@interface ELChangePassViewController ()

@property (nonatomic, strong) NSDictionary *formGroupsDict;
@property (nonatomic, strong) ELAccountsViewManager *viewManager;
@property (nonatomic, strong) ELFormItemGroup *currentPasswordGroup,
                                              *passwordGroup,
                                              *confirmPasswordGroup;

@end

@implementation ELChangePassViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.viewManager = [[ELAccountsViewManager alloc] init];
    self.viewManager.delegate = self;
    self.currentPasswordTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
    self.currentPasswordGroup = [[ELFormItemGroup alloc] initWithInput:self.currentPasswordTextField
                                                                  icon:nil
                                                            errorLabel:self.currentPasswordErrorLabel];
    self.passwordGroup = [[ELFormItemGroup alloc] initWithInput:self.passwordTextField
                                                           icon:nil
                                                     errorLabel:self.passwordErrorLabel];
    self.confirmPasswordGroup = [[ELFormItemGroup alloc] initWithInput:self.confirmPasswordTextField
                                                                  icon:nil
                                                            errorLabel:self.confirmPasswordErrorLabel];
    self.formGroupsDict = @{@"currentPassword": self.currentPasswordGroup,
                            @"password": self.passwordGroup,
                            @"confirmPassword": self.confirmPasswordGroup};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Clear form
    self.currentPasswordTextField.text = @"";
    self.passwordTextField.text = @"";
    self.confirmPasswordTextField.text = @"";
}

#pragma mark - Protocol Methods (UITextField)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    return YES;
}

#pragma mark - Protocol Methods (ELAccountsViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    NSString *errorKey = @"validation_errors";
    
    self.saveButton.enabled = YES;
    
    if (!errorDict[errorKey]) {
        return;
    }
    
    for (NSString *key in [errorDict[errorKey] allKeys]) {
        NSArray *errors = errorDict[errorKey][key];
        
        [self.formGroupsDict[key] toggleValidationIndicatorsBasedOnErrors:errors];
    }
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    // Update password stored on NSUserDefaults
    NSMutableDictionary *mCredentialsDict = [[ELUtils getUserDefaultsObjectForKey:kELAuthCredentialsUserDefaultsKey] mutableCopy];
    
    [mCredentialsDict setObject:self.confirmPasswordTextField.text
                         forKey:@"password"];
    [ELUtils setUserDefaultsObject:[mCredentialsDict copy]
                               key:kELAuthCredentialsUserDefaultsKey];
    
    // Exit
    [self.saveButton setEnabled:YES];
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELProfileChangePasswordSuccess", nil)
                     completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Interface Builder Actions

- (IBAction)onSaveButtonClick:(id)sender {
    BOOL isValid = [self.viewManager validateChangePasswordFormValues:self.formGroupsDict];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (!isValid) {
        return;
    }
    
    [self.saveButton setEnabled:NO];
    [self.viewManager processChangePassword];
}

@end
