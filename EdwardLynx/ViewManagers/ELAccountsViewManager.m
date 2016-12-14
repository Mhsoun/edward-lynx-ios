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
    [self.client authenticateWithUsername:self.formDict[@"username"]
                                 password:self.formDict[@"password"]
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
    
    self.formDict = formDict;
    
    if (formDict[@"username"]) {
        usernameErrors = [REValidation validateObject:formDict[@"username"]
                                                 name:@"Username"
                                           validators:@[@"presence", @"length(4, 20)"]];
        
        for (NSError *error in usernameErrors) {
            // TODO Display error messages to app
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }
    
    if (formDict[@"password"]) {
        passwordErrors = [REValidation validateObject:formDict[@"password"]
                                                 name:@"Password"
                                           validators:@[@"presence", @"length(4, 20)"]];
        
        for (NSError *error in passwordErrors) {
            // TODO Display error messages to app
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }
    
    return usernameErrors.count == 0 && passwordErrors.count == 0;
}

- (BOOL)validateRecoverFormValues:(NSDictionary *)formDict {
    NSArray *emailErrors;
    
    self.formDict = formDict;
    
    if (formDict[@"email"]) {
        emailErrors = [REValidation validateObject:formDict[@"email"]
                                              name:@"Email"
                                        validators:@[@"presence", @"email"]];
        
        for (NSError *error in emailErrors) {
            // TODO Display error messages to app
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }
    
    return emailErrors.count == 0;
}

#pragma mark - Private Methods

- (void)setupValidators {
    [REValidation registerDefaultValidators];
    [REValidation registerDefaultErrorMessages];
}

@end
