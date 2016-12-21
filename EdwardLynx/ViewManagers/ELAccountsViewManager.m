//
//  ELAccountsViewManager.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 13/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAccountsViewManager.h"

@interface ELAccountsViewManager ()

@property (nonatomic, strong) NSDictionary *formDict;
@property (nonatomic, strong) ELUsersAPIClient *client;

@end

@implementation ELAccountsViewManager

- (instancetype)init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _formDict = @{};
    _client = [[ELUsersAPIClient alloc] init];
    
    [self setupValidators];
    
    return self;
}

#pragma mark - Public Methods

- (void)processProfileUpdate {
    [self.client updateUserInfoWithParams:@{@"name": [self.formDict[@"name"] textValue],
                                            @"info": [self.formDict[@"info"] textValue]}
                               completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self.delegate onAPIResponseError:error.userInfo];
                
                return;
            }
            
            [self.delegate onAPIResponseSuccess:responseDict];
        });
    }];
}

- (void)processAuthentication {
    [self.client loginWithUsername:[self.formDict[@"username"] textValue]
                          password:[self.formDict[@"password"] textValue]
                        completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self.delegate onAPIResponseError:error.userInfo];
                
                return;
            }
            
            // Set Refresh Token and Authentication header
            [ELUtils storeAuthenticationDetails:responseDict];
            [self.delegate onAPIResponseSuccess:responseDict];
        });
    }];
}

- (void)processChangePassword {
    [self.client updateUserInfoWithParams:@{@"password": [self.formDict[@"password"] textValue],
                                            @"currentPassword": [self.formDict[@"currentPassword"] textValue]}
                               completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self.delegate onAPIResponseError:error.userInfo];
                
                return;
            }
            
            [self.delegate onAPIResponseSuccess:responseDict];
        });
    }];
}

- (void)processPasswordRecovery {
    // TODO Process recovery
}

- (BOOL)validateLoginFormValues:(NSDictionary *)formDict {
    NSString *key;
    NSArray *usernameErrors, *passwordErrors;
    ELTextFieldGroup *textFieldGroup;
    
    self.formDict = formDict;
    key = @"username";
    
    if (formDict[key]) {
        textFieldGroup = formDict[key];
        usernameErrors = [REValidation validateObject:[textFieldGroup textValue]
                                                 name:@"Username"
                                           validators:@[@"presence", @"length(4, 20)"]];
        
        [textFieldGroup toggleValidationIndicatorsBasedOnErrors:usernameErrors];
    }
    
    key = @"password";
    
    if (formDict[key]) {
        textFieldGroup = formDict[key];
        passwordErrors = [REValidation validateObject:[textFieldGroup textValue]
                                                 name:@"Password"
                                           validators:@[@"presence", @"length(4, 20)"]];
        
        [textFieldGroup toggleValidationIndicatorsBasedOnErrors:passwordErrors];
    }
    
    return usernameErrors.count == 0 && passwordErrors.count == 0;
}

- (BOOL)validateRecoverFormValues:(NSDictionary *)formDict {
    NSArray *emailErrors;
    ELTextFieldGroup *textFieldGroup;
    NSString *key = @"email";
    
    self.formDict = formDict;
    
    if (formDict[key]) {
        textFieldGroup = formDict[key];
        emailErrors = [REValidation validateObject:[textFieldGroup textValue]
                                              name:@"Email"
                                        validators:@[@"presence", @"email"]];
        
        [textFieldGroup toggleValidationIndicatorsBasedOnErrors:emailErrors];
    }
    
    return emailErrors.count == 0;
}

- (BOOL)validateProfileUpdateFormValues:(NSDictionary *)formDict {
    NSArray *nameErrors;
    ELTextFieldGroup *textFieldGroup;
    NSString *key = @"name";
    
    self.formDict = formDict;
    
    if (formDict[key]) {
        textFieldGroup = formDict[key];
        nameErrors = [REValidation validateObject:[textFieldGroup textValue]
                                             name:@"Name"
                                        validators:@[@"presence"]];
        
        [textFieldGroup toggleValidationIndicatorsBasedOnErrors:nameErrors];
    }
    
    return nameErrors.count == 0;
}

- (BOOL)validateChangePasswordFormValues:(NSDictionary *)formDict {
    NSArray *errors;
    ELTextFieldGroup *textFieldGroup;
    BOOL isValid = YES, isEqual = NO;
    
    self.formDict = formDict;
    isEqual = ([[formDict[@"password"] textValue] isEqualToString:[formDict[@"confirmPassword"] textValue]]);
    
    for (NSString *key in [formDict allKeys]) {
        textFieldGroup = formDict[key];
        errors = [REValidation validateObject:[textFieldGroup textValue]
                                                 name:@"Field"
                                           validators:@[@"presence", @"length(4, 20)"]];
        isValid = isValid && errors.count == 0;
        
        [textFieldGroup toggleValidationIndicatorsBasedOnErrors:errors];
    }
    
    if (!isEqual) {
        [formDict[@"password"] toggleValidationIndicatorsBasedOnErrors:@[@"New Password fields must be the same."]];
    }
    
    return isValid && isEqual;
}

#pragma mark - Private Methods

- (void)setupValidators {
    [REValidation registerDefaultValidators];
    [REValidation registerDefaultErrorMessages];
}

@end
