//
//  ELAccountsViewManager.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 13/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAccountsViewManager.h"

@interface ELAccountsViewManager ()

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSDictionary *formDict;
@property (nonatomic, strong) ELUsersAPIClient *client;

@end

@implementation ELAccountsViewManager

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _view = view;
    _formDict = @{};
    _client = [[ELUsersAPIClient alloc] init];
    
    [self setupValidators];
    
    return self;
}

#pragma mark - Public Methods

- (void)processAuthentication {
    [self.client authenticateWithUsername:[self.formDict[@"username"] textValue]
                                 password:[self.formDict[@"password"] textValue]
                               completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        if (error) {
            return;
        }
        
        NSLog(@"%@: %@", [self.client class], responseDict);
    }];
}

- (void)processPasswordRecovery {
    // TODO Process recovery
}

- (BOOL)validateLoginFormValues:(NSDictionary *)formDict {
    NSArray *usernameErrors, *passwordErrors;
    ELTextFieldGroup *textFieldGroup;
    
    self.formDict = formDict;
    
    if (formDict[@"username"]) {
        textFieldGroup = formDict[@"username"];
        usernameErrors = [REValidation validateObject:[textFieldGroup textValue]
                                                 name:@"Username"
                                           validators:@[@"presence", @"length(4, 20)"]];
        
        [textFieldGroup toggleValidationIndicatorsBasedOnErrors:usernameErrors];
        
        // TODO Display error messages to app
    }
    
    if (formDict[@"password"]) {
        textFieldGroup = formDict[@"password"];
        passwordErrors = [REValidation validateObject:[textFieldGroup textValue]
                                                 name:@"Password"
                                           validators:@[@"presence", @"length(4, 20)"]];
        
        [textFieldGroup toggleValidationIndicatorsBasedOnErrors:passwordErrors];
        
        // TODO Display error messages to app
    }
    
    return usernameErrors.count == 0 && passwordErrors.count == 0;
}

- (BOOL)validateRecoverFormValues:(NSDictionary *)formDict {
    NSArray *emailErrors;
    ELTextFieldGroup *textFieldGroup;
    
    self.formDict = formDict;
    
    if (formDict[@"email"]) {
        textFieldGroup = formDict[@"email"];
        emailErrors = [REValidation validateObject:[textFieldGroup textValue]
                                              name:@"Email"
                                        validators:@[@"presence", @"email"]];
        
        [textFieldGroup toggleValidationIndicatorsBasedOnErrors:emailErrors];
        
        // TODO Display error messages to app
    }
    
    return emailErrors.count == 0;
}

#pragma mark - Private Methods

- (void)setupValidators {
    [REValidation registerDefaultValidators];
    [REValidation registerDefaultErrorMessages];
}

@end