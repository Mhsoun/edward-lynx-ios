//
//  ELChangePassViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELChangePassViewController.h"

#pragma mark - Private Constants

static CGFloat const kELCornerRadius = 4.0f;

#pragma mark - Class Extension

@interface ELChangePassViewController ()

@property (nonatomic, strong) NSDictionary *formGroupsDict;
@property (nonatomic, strong) ELAccountsViewManager *viewManager;
@property (nonatomic, strong) ELTextFieldGroup *currentPasswordGroup,
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
    self.currentPasswordGroup = [[ELTextFieldGroup alloc] initWithField:self.currentPasswordTextField
                                                                   icon:nil
                                                             errorLabel:self.currentPasswordErrorLabel];
    self.passwordGroup = [[ELTextFieldGroup alloc] initWithField:self.passwordTextField
                                                            icon:nil
                                                      errorLabel:self.passwordErrorLabel];
    self.confirmPasswordGroup = [[ELTextFieldGroup alloc] initWithField:self.confirmPasswordTextField
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

#pragma mark - Protocol Methods (UITextField)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    return YES;
}

#pragma mark - Protocol Methods (ELAccountsViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    NSString *errorKey = @"validation_errors";
    
    if (!errorDict[errorKey]) {
        return;
    }
    
    for (NSString *key in [errorDict[errorKey] allKeys]) {
        NSArray *errors = errorDict[errorKey][key];
        
        [self.formGroupsDict[key] toggleValidationIndicatorsBasedOnErrors:errors];
    }
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    // Fields
    self.currentPasswordView.layer.cornerRadius = kELCornerRadius;
    self.passwordView.layer.cornerRadius = kELCornerRadius;
    self.confirmPasswordView.layer.cornerRadius = kELCornerRadius;
}

#pragma mark - Interface Builder Actions

- (IBAction)onDoneClick:(id)sender {
    BOOL isValid = [self.viewManager validateChangePasswordFormValues:self.formGroupsDict];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (!isValid) {
        return;
    }
    
    [self.viewManager processChangePassword];
}

@end
