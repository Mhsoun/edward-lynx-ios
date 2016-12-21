//
//  ELEditProfileViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELEditProfileViewController.h"

#pragma mark - Private Constants

static CGFloat const kELCornerRadius = 4.0f;

#pragma mark - Class Extension

@interface ELEditProfileViewController ()

@property (nonatomic, strong) NSDictionary *formGroupsDict;
@property (nonatomic, strong) ELAccountsViewManager *viewManager;
@property (nonatomic, strong) ELTextFieldGroup *nameGroup,
                                               *infoGroup;

@end

@implementation ELEditProfileViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.viewManager = [[ELAccountsViewManager alloc] init];
    self.viewManager.delegate = self;
    self.nameGroup = [[ELTextFieldGroup alloc] initWithField:self.nameTextField
                                                        icon:nil
                                                  errorLabel:self.nameErrorLabel];
    self.infoGroup = [[ELTextFieldGroup alloc] initWithField:self.infoTextField
                                                        icon:nil
                                                  errorLabel:self.infoErrorLabel];
    self.formGroupsDict = @{@"name": self.nameGroup, @"info": self.infoGroup};
    
    [self populatePage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)populatePage {
    self.nameTextField.text = self.userInfoDict[@"name"];
    self.infoTextField.text = self.userInfoDict[@"info"];
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
    self.nameView.layer.cornerRadius = kELCornerRadius;
    self.infoView.layer.cornerRadius = kELCornerRadius;
}

#pragma mark - Interface Builder Actions

- (IBAction)onDoneClick:(id)sender {
    BOOL isValid = [self.viewManager validateProfileUpdateFormValues:self.formGroupsDict];
    
    if (!isValid) {
        return;
    }
    
    [self.viewManager processProfileUpdate];
}

@end
