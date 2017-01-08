//
//  ELInviteUsersViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELInviteUsersViewController.h"

#pragma mark - Private Constants

static NSString * const kELNoParticipantRole = @"No role selected";

#pragma mark - Class Extension

@interface ELInviteUsersViewController ()

@property (nonatomic, strong) ELFeedbackViewManager *viewManager;

@end

@implementation ELInviteUsersViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.viewManager = [[ELFeedbackViewManager alloc] init];
    self.roleLabel.text = kELNoParticipantRole;
    
    NSLog(@"%@", self.instantFeedbackDict);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface Builder Actions

- (IBAction)onRoleButtonClick:(id)sender {

}

- (IBAction)onAddButtonClick:(id)sender {
    BOOL isValid;
    ELFormItemGroup *nameGroup,
                    *emailGroup,
                    *roleGroup;
    
    nameGroup = [[ELFormItemGroup alloc] initWithText:self.nameTextField.text
                                                 icon:nil
                                           errorLabel:self.nameErrorLabel];
    emailGroup = [[ELFormItemGroup alloc] initWithText:self.emailTextField.text
                                                     icon:nil
                                               errorLabel:self.emailErrorLabel];
    roleGroup = [[ELFormItemGroup alloc] initWithText:self.roleLabel.text
                                                 icon:nil
                                           errorLabel:self.roleErrorLabel];
    isValid = [self.viewManager validateInstantFeedbackInviteUsersFormValues:@{@"name": nameGroup,
                                                                               @"email": emailGroup,
                                                                               @"role": roleGroup}];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (!isValid) {
        return;
    }
    
    // TODO API call
}

@end
