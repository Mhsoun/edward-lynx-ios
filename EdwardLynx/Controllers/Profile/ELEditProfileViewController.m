//
//  ELEditProfileViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELEditProfileViewController.h"

#pragma mark - Class Extension

@interface ELEditProfileViewController ()

@property (nonatomic, strong) NSString *selectedGender;
@property (nonatomic, strong) NSDictionary *formGroupsDict;
@property (nonatomic, strong) ELFormItemGroup *nameGroup, *emailGroup;
@property (nonatomic, strong) TNRadioButtonGroup *radioGroup;
@property (nonatomic, strong) ELAccountsViewManager *viewManager;

@end

@implementation ELEditProfileViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.nameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.roleTextField.delegate = self;
    self.departmentTextField.delegate = self;
    self.countryTextField.delegate = self;
    self.cityTextField.delegate = self;
    self.nameGroup = [[ELFormItemGroup alloc] initWithField:self.nameTextField
                                                       icon:nil
                                                 errorLabel:self.nameErrorLabel];
    self.emailGroup = [[ELFormItemGroup alloc] initWithField:self.emailTextField
                                                        icon:nil
                                                  errorLabel:self.emailErrorLabel];
    self.formGroupsDict = @{@"name": self.nameGroup, @"email": self.emailGroup};
    self.viewManager = [[ELAccountsViewManager alloc] init];
    self.viewManager.delegate = self;
    
    // Fill in with user information
    [self populatePage];
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
    [self.saveButton setEnabled:YES];
    
    [ELUtils presentToastAtView:self.view
                        message:@"Profile update successful."
                     completion:^{
        [[ELAppSingleton sharedInstance] setUser:[[ELUser alloc] initWithDictionary:responseDict
                                                                              error:nil]];
    }];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    NSArray *genders = @[@"Male", @"Female", @"Other"];
    NSMutableArray *mData = [[NSMutableArray alloc] init];
    
    // Radio Group
    for (int i = 0; i < genders.count; i++) {
        NSString *genderType = genders[i];
        TNCircularRadioButtonData *data = [TNCircularRadioButtonData new];
        
        data.selected = i == 0;
        data.identifier = [genderType lowercaseString];
        
        data.labelText = genderType;
        data.labelFont = [UIFont fontWithName:@"Lato-Regular" size:14];
        data.labelColor = [UIColor whiteColor];
        
        data.borderColor = [UIColor whiteColor];
        data.circleColor = [UIColor whiteColor];
        data.borderRadius = 15;
        data.circleRadius = 10;
        
        [mData addObject:data];
    }
    
    self.radioGroup = [[TNRadioButtonGroup alloc] initWithRadioButtonData:[mData copy]
                                                                   layout:TNRadioButtonGroupLayoutVertical];
    
    [self.radioGroup setIdentifier:@"Gender group"];
    [self.radioGroup setMarginBetweenItems:15];
    
    [self.radioGroup create];
    [self.radioGroupView addSubview:self.radioGroup];
    
    // Notification to handle selection changes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onGenderTypeGroupUpdate:)
                                                 name:SELECTED_RADIO_BUTTON_CHANGED
                                               object:self.radioGroup];
}

#pragma mark - Private Methods

- (void)populatePage {
    ELUser *user = [ELAppSingleton sharedInstance].user;
    
    self.nameTextField.text = user.name;
    self.emailTextField.text = user.email;
}

#pragma mark - Interface Builder Actions

- (IBAction)onSaveButtonClick:(id)sender {
    BOOL isValid = [self.viewManager validateProfileUpdateFormValues:self.formGroupsDict];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (!isValid) {
        return;
    }
    
    [self.saveButton setEnabled:NO];
    [self.viewManager processProfileUpdate];
}

#pragma mark - Notifications

- (void)onGenderTypeGroupUpdate:(NSNotification *)notification {
    self.selectedGender = self.radioGroup.selectedRadioButton.data.identifier;
}

@end
