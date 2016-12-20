//
//  ELChangePassViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELChangePassViewController.h"

#pragma mark - Private Constants

static CGFloat const kICornerRadius = 4.0f;

@interface ELChangePassViewController ()

@property (nonatomic, strong) NSDictionary *formGroupsDict;
@property (nonatomic, strong) ELAccountsViewManager *viewManager;
@property (nonatomic, strong) ELTextFieldGroup *currentPasswordGroup,
                                               *passwordGroup,
                                               *confirmPasswordGroup;

@end

@implementation ELChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewManager = [[ELAccountsViewManager alloc] init];
    self.viewManager.delegate = self;
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

#pragma mark - Protocol Methods (ELAccountsViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    if (!errorDict[@"message"]) {
        return;
    }
    
    for (NSString *key in [errorDict[@"message"] allKeys]) {
        NSArray *errors = errorDict[@"message"][key];
        
        [self.formGroupsDict[key] toggleValidationIndicatorsBasedOnErrors:errors];
    }
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    // Fields
    self.currentPasswordView.layer.cornerRadius = kICornerRadius;
    self.passwordView.layer.cornerRadius = kICornerRadius;
    self.confirmPasswordView.layer.cornerRadius = kICornerRadius;
}

#pragma mark - Interface Builder Actions

- (IBAction)onDoneClick:(id)sender {
    BOOL isValid = [self.viewManager validateChangePasswordFormValues:self.formGroupsDict];
    
    if (!isValid) {
        return;
    }
    
    [self.viewManager processChangePassword];
}

@end
