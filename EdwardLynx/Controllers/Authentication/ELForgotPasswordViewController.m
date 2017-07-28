//
//  ELForgotPasswordViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 13/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELForgotPasswordViewController.h"
#import "ELAccountsViewManager.h"

#pragma mark - Private Constants

static CGFloat const kELCornerRadius = 2.0f;

#pragma mark - Class Extension

@interface ELForgotPasswordViewController ()

@property (nonatomic, strong) ELAccountsViewManager *viewManager;

@end

@implementation ELForgotPasswordViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.recoverPasswordLabel.text = [self.recoverPasswordLabel.text uppercaseString];
    self.usernameEmailTextField.delegate = self;
    
    self.viewManager = [[ELAccountsViewManager alloc] init];
    self.viewManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Protocol Methods (UITextField)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    return YES;
}

#pragma mark - Protocol Methods (ELAccountsViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [self.recoverButton setEnabled:YES];
    [ELUtils presentToastAtView:self.view
                        message:errorDict[@"message"]
                     completion:nil];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    [self.recoverButton setEnabled:YES];
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELForgotPasswordSuccessMessage", nil)
                     completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    CAGradientLayer *gradient;
    
    // Button
    self.recoverButton.layer.cornerRadius = kELCornerRadius;
    
    // View
    gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)ThemeColor(kELDarkVioletColor).CGColor,
                       (id)ThemeColor(kELVioletColor).CGColor,
                       nil];
    
    [self.view setTintColor:ThemeColor(kELLightVioletColor)];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

#pragma mark - Interface Builder Actions

- (IBAction)onRecoverButtonClick:(id)sender {
    BOOL isValid;
    ELFormItemGroup *formFieldGroup = [[ELFormItemGroup alloc] initWithInput:self.usernameEmailTextField
                                                                        icon:self.usernameEmailIcon
                                                                  errorLabel:self.usernameEmailErrorLabel];
    
    isValid = [self.viewManager validateRecoverFormValues:@{@"email": formFieldGroup}];
    
    if (!isValid) {
        return;
    }
    
    [self.recoverButton setEnabled:NO];
    [self.viewManager processPasswordRecovery];
}

- (IBAction)onBackButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
