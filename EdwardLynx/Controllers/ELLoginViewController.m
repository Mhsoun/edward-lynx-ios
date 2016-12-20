//
//  ELLoginViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELLoginViewController.h"

#pragma mark - Private Constants

static CGFloat const kICornerRadius = 2.0f;

@interface ELLoginViewController ()

@property (nonatomic, strong) ELAccountsViewManager *viewManager;
@property (nonatomic, strong) ELTextFieldGroup *usernameGroup, *passwordGroup;

@end

@implementation ELLoginViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.viewManager = [[ELAccountsViewManager alloc] init];
    self.viewManager.delegate = self;
    self.usernameGroup = [[ELTextFieldGroup alloc] initWithField:self.usernameTextField
                                                            icon:self.usernameIcon
                                                      errorLabel:self.usernameErrorLabel];
    self.passwordGroup = [[ELTextFieldGroup alloc] initWithField:self.passwordTextField
                                                            icon:self.passwordIcon
                                                      errorLabel:self.passwordErrorLabel];
    
    self.usernameTextField.text = @"admin@edwardlynx.com";
    self.passwordTextField.text = @"password123";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    CAGradientLayer *gradient;
    
    // Fields
    self.usernameView.layer.cornerRadius = kICornerRadius;
    self.passwordView.layer.cornerRadius = kICornerRadius;
    
    // Button
    self.loginButton.layer.cornerRadius = kICornerRadius;
    
    // View
    gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[RNThemeManager sharedManager] colorForKey:kELDarkVioletColor].CGColor,
                       (id)[[RNThemeManager sharedManager] colorForKey:kELVioletColor].CGColor,
                       nil];
    
    [self.view setTintColor:[[RNThemeManager sharedManager] colorForKey:kELLightVioletColor]];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

#pragma mark - Protocol Methods (ELAccountsViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    self.loginButton.enabled = YES;
    
    if (!errorDict[@"message"]) {
        return;
    }
    
    [self.usernameGroup toggleValidationIndicatorsBasedOnErrors:@[errorDict[@"message"]]];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    self.loginButton.enabled = YES;
    
    [self presentViewController:[[UIStoryboard storyboardWithName:@"LeftMenu" bundle:nil] instantiateInitialViewController]
                       animated:YES
                     completion:nil];
}

#pragma mark - Interface Builder Actions

- (IBAction)onLoginButtonClick:(id)sender {
    BOOL isValid = [self.viewManager validateLoginFormValues:@{@"username": self.usernameGroup,
                                                               @"password": self.passwordGroup}];
    
    self.loginButton.enabled = NO;
    
    if (!isValid) {
        self.loginButton.enabled = YES;
        
        return;
    }
    
    [self.viewManager processAuthentication];
}

@end
