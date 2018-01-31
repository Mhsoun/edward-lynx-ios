//
//  ELLoginViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELLoginViewController.h"
#import "ELAPIClient.h"
#import "ELAccountsViewManager.h"
#import "ELOAuthInstance.h"

#pragma mark - Private Constants

static CGFloat const kELCornerRadius = 2.0f;

#pragma mark - Class Extension

@interface ELLoginViewController ()

@property (nonatomic, strong) ELAccountsViewManager *viewManager;
@property (nonatomic, strong) ELFormItemGroup *usernameGroup;

@end

@implementation ELLoginViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.viewManager = [[ELAccountsViewManager alloc] init];
    self.viewManager.delegate = self;
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.usernameGroup = [[ELFormItemGroup alloc] initWithInput:self.usernameTextField
                                                           icon:self.usernameIcon
                                                     errorLabel:self.usernameErrorLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    NSDictionary *credentials = [ELUtils getUserDefaultsObjectForKey:kELAuthCredentialsUserDefaultsKey];
    
    self.usernameTextField.text = credentials[@"username"];
    self.passwordTextField.text = credentials[@"password"];
    
    [super viewWillAppear:animated];
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
    NSString *errorKey = @"message";
    
    self.loginButton.enabled = YES;
    
    if (!errorDict[errorKey]) {
        return;
    }
    
    [self.usernameGroup toggleValidationIndicatorsBasedOnErrors:@[errorDict[errorKey]]];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    self.loginButton.enabled = YES;
    
    // Store values
    [ELUtils setUserDefaultsObject:@{@"username": self.usernameTextField.text,
                                     @"password": self.passwordTextField.text}
                               key:kELAuthCredentialsUserDefaultsKey];
    
    // Store authentication details in a custom object
    [ELUtils setUserDefaultsCustomObject:[[ELOAuthInstance alloc] initWithDictionary:responseDict error:nil]
                                     key:kELAuthInstanceUserDefaultsKey];
    
    [self performSegueWithIdentifier:@"Configuration" sender:self];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    CAGradientLayer *gradient;
    
    // Icons
    self.usernameIcon.tintColor = [UIColor grayColor];
    self.passwordIcon.tintColor = [UIColor grayColor];
        
    // Button
    [self.loginButton.layer setCornerRadius:kELCornerRadius];
    [self.loginButton setTitle:NSLocalizedString(@"kELLoginButtonNormalText", nil)
                      forState:UIControlStateNormal];
    [self.loginButton setTitle:NSLocalizedString(@"kELLoginButtonDisabledText", nil)
                      forState:UIControlStateDisabled];
    
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

- (IBAction)onLoginButtonClick:(id)sender {
    BOOL isValid;
    ELFormItemGroup *passwordGroup = [[ELFormItemGroup alloc] initWithInput:self.passwordTextField
                                                                       icon:self.passwordIcon
                                                                 errorLabel:self.passwordErrorLabel];
    
    isValid = [self.viewManager validateLoginFormValues:@{@"username": self.usernameGroup,
                                                          @"password": passwordGroup}];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (!isValid) {
        return;
    }
    
    [self.loginButton setEnabled:NO];
    [self.viewManager processAuthentication];
}

- (IBAction)onContactUsButtonClick:(id)sender {
    [Application openURL:[NSURL URLWithString:kELEdwardLynxContactUsURL]];
}

@end
