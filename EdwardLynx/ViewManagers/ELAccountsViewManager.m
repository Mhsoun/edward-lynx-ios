//
//  ELAccountsViewManager.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 13/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <REValidation/REValidation.h>

#import "ELAccountsViewManager.h"
#import "ELUsersAPIClient.h"

#pragma mark - Class Extension

@interface ELAccountsViewManager ()

@property (nonatomic, strong) NSDictionary *formDict;
@property (nonatomic, strong) ELUsersAPIClient *client;
@property (nonatomic, strong) void (^requestCompletionBlock)(NSURLResponse *response, NSDictionary *responseDict, NSError *error);

@end

@implementation ELAccountsViewManager

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _client = [[ELUsersAPIClient alloc] init];
    _formDict = @{};
        
    __weak typeof(self) weakSelf = self;
    
    self.requestCompletionBlock = ^(NSURLResponse *response,
                                    NSDictionary *responseDict,
                                    NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [weakSelf.delegate onAPIResponseError:error.userInfo];
                
                return;
            }
            
            [weakSelf.delegate onAPIResponseSuccess:responseDict];
        });
    };
    
    [ELUtils registerValidators];
    
    return self;
}

#pragma mark - Public Methods

- (void)processProfileUpdate {
    [self.client updateUserInfoWithParams:@{@"name": [self.formDict[@"name"] textValue],
                                            @"info": [self.formDict[@"info"] textValue],
                                            @"role": [self.formDict[@"role"] textValue],
                                            @"department": [self.formDict[@"department"] textValue],
                                            @"gender": [self.formDict[@"gender"] textValue],
                                            @"city": [self.formDict[@"city"] textValue],
                                            @"country": [self.formDict[@"country"] textValue]}
                               completion:self.requestCompletionBlock];
}

- (void)processAuthentication {
    [self.client loginWithUsername:[self.formDict[@"username"] textValue]
                          password:[self.formDict[@"password"] textValue]
                        completion:self.requestCompletionBlock];
}

- (void)processChangePassword {
    [self.client updateUserInfoWithParams:@{@"password": [self.formDict[@"password"] textValue],
                                            @"currentPassword": [self.formDict[@"currentPassword"] textValue]}
                               completion:self.requestCompletionBlock];
}

- (void)processPasswordRecovery {
    [self.client recoverPasswordThruEmail:[self.formDict[@"email"] textValue]
                               completion:self.requestCompletionBlock];
}

- (BOOL)validateLoginFormValues:(NSDictionary *)formDict {
    NSString *key;
    NSArray *usernameErrors, *passwordErrors;
    ELFormItemGroup *formFieldGroup;
    
    self.formDict = formDict;
    key = @"username";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
//        usernameErrors = [REValidation validateObject:[formFieldGroup textValue]
//                                                 name:NSLocalizedString(@"kELUsernameField", nil)
//                                           validators:@[@"presence", @"email"]];

        usernameErrors = [[formFieldGroup textValue] length] == 0 ? @[NSLocalizedString(@"kELLoginUsernameValidationMessage", nil)] : nil;
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:usernameErrors];
    }
    
    key = @"password";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
//        passwordErrors = [REValidation validateObject:[formFieldGroup textValue]
//                                                 name:NSLocalizedString(@"kELPasswordField", nil)
//                                           validators:@[@"presence"]];
        
        passwordErrors = [[formFieldGroup textValue] length] == 0 ? @[NSLocalizedString(@"kELLoginPasswordValidationMessage", nil)] : nil;
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:passwordErrors];
    }
    
    return usernameErrors.count == 0 && passwordErrors.count == 0;
}

- (BOOL)validateRecoverFormValues:(NSDictionary *)formDict {
    NSArray *emailErrors;
    ELFormItemGroup *formFieldGroup;
    NSString *key = @"email";
    
    self.formDict = formDict;
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
        emailErrors = [REValidation validateObject:[formFieldGroup textValue]
                                              name:NSLocalizedString(@"kELUsernameField", nil)
                                        validators:@[@"presence", @"email"]];
        emailErrors = emailErrors.count > 0 ? @[NSLocalizedString(@"kELRecoverEmailValidationMessage", nil)] : nil;
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:emailErrors];
    }
    
    return emailErrors.count == 0;
}

- (BOOL)validateProfileUpdateFormValues:(NSDictionary *)formDict {
    NSArray *nameErrors;
    ELFormItemGroup *formFieldGroup;
    NSString *key = @"name";
    
    self.formDict = formDict;
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
//        nameErrors = [REValidation validateObject:[formFieldGroup textValue]
//                                             name:NSLocalizedString(@"kELNameField", nil)
//                                       validators:@[@"presence"]];
        
        nameErrors = [[formFieldGroup textValue] length] == 0 ? @[NSLocalizedString(@"kELNameValidationMessage", nil)] : nil;
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:nameErrors];
    }
    
    return nameErrors.count == 0;
}

- (BOOL)validateChangePasswordFormValues:(NSDictionary *)formDict {
    NSArray *errors;
    ELFormItemGroup *formFieldGroup;
    BOOL isValid = YES, isEqual = NO;
    
    self.formDict = formDict;
    isEqual = ([[formDict[@"password"] textValue] isEqualToString:[formDict[@"confirmPassword"] textValue]]);
    
    for (NSString *key in [formDict allKeys]) {
        formFieldGroup = formDict[key];
//        errors = [REValidation validateObject:[formFieldGroup textValue]
//                                         name:NSLocalizedString(@"kELDefaultField", nil)
//                                   validators:@[@"presence"]];
        
        errors = [[formFieldGroup textValue] length] == 0 ? @[NSLocalizedString(@"kELFieldValidationMessage", nil)] : nil;
        isValid = isValid && errors.count == 0;
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:errors];
    }
    
    if (!isEqual) {
        [formDict[@"password"] toggleValidationIndicatorsBasedOnErrors:@[NSLocalizedString(@"kELPasswordValidationMessage", nil)]];
    }
    
    return isValid && isEqual;
}

@end
