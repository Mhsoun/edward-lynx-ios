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
    self.viewManager.delegate = self;
    self.roleLabel.text = kELNoParticipantRole;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (ELFeedbackViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    // TODO Implementation
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    // TODO Implementation
}

#pragma mark - Interface Builder Actions

- (IBAction)onRoleButtonClick:(id)sender {

}

- (IBAction)onAddButtonClick:(id)sender {
    BOOL isValid;
    NSDictionary *formDict;
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
    
    // TEMP Form data
    formDict = @{@"name": @"",
                 @"lang": @"en",
                 @"type": @"instant",
                 @"startDate": @"",
                 @"endDate": @"",
                 @"description": @"",
                 @"inviteText": @"",
                 @"thankYouText": @"",
                 @"questionInfoText": @"",
                 @"questions": @[@{@"text": [self.instantFeedbackDict[@"question"] textValue],
                                   @"isNA": @NO,
                                   @"answer": @{@"type": @([ELUtils answerTypeByLabel:[self.instantFeedbackDict[@"type"] textValue]]),
                                                @"options": @[]}}],
                 @"recipients": @[]};
    
//    [self.viewManager processInstantFeedback:formDict];
}

@end
