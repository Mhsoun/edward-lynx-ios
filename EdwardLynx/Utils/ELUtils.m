//
//  ELUtils.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELUtils.h"

@interface ELTextFieldGroup ()

@property (nonatomic, strong) __kindof UITextField *textField;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *errorLabel;

@end

@implementation ELTextFieldGroup

- (instancetype)initWithField:(__kindof UITextField *)textField
                         icon:(UIImageView *)icon
                   errorLabel:(UILabel *)errorLabel {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _textField = textField;
    _icon = icon;
    _errorLabel = errorLabel;
    
    return self;
}

- (NSString *)textValue {
    return self.textField.text;
}

- (void)toggleValidationIndicatorsBasedOnErrors:(NSArray *)errors {
    BOOL isValid = errors.count == 0;
    id error = isValid ? nil : errors[0];
    
    // Label
    self.errorLabel.text = !isValid ? ([error isKindOfClass:[NSError class]] ? [errors[0] localizedDescription] : error) : @"";
    self.errorLabel.hidden = isValid;
    
    // Icon
    [self.icon setImage:[self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.icon setTintColor:isValid ? [[RNThemeManager sharedManager] colorForKey:kELDarkGrayColor] :
                                      [UIColor redColor]];
}

@end

@implementation ELUtils

+ (id)getUserDefaultValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (void)processReauthenticationWithCompletion:(void (^)())completion {
    [[[ELUsersAPIClient alloc] init] reauthenticateWithCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self storeAuthenticationDetails:responseDict];
            
            completion();
        });
    }];
}

+ (void)setUserDefaultValue:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

+ (void)storeAuthenticationDetails:(NSDictionary *)authDict {
    [ELUtils setUserDefaultValue:authDict[@"refresh_token"] forKey:kELRefreshTokenUserDefaultsKey];
    [ELUtils setUserDefaultValue:[NSString stringWithFormat:@"Bearer %@", authDict[@"access_token"]]
                          forKey:kELAuthHeaderUserDefaultsKey];
}

#pragma mark - Third-party Packages Methods

+ (void)fabricForceCrash {
    // TODO Fill in with actual user information
    [ELUtils fabricLogUserInformation:@{kELFabricUsername: @"someuser",
                                        kELFabricEmail: @"someuser@gmail.com",
                                        kELFabricIdentifier: @"someuser123"}];
    [[Crashlytics sharedInstance] crash];
}

+ (void)fabricLogUserInformation:(NSDictionary *)infoDict {
    [[Crashlytics sharedInstance] setUserName:infoDict[kELFabricUsername]];
    [[Crashlytics sharedInstance] setUserEmail:infoDict[kELFabricEmail]];
    [[Crashlytics sharedInstance] setUserIdentifier:infoDict[kELFabricIdentifier]];
}

#pragma mark - Third-party Packages Setup

+ (void)setupFabric {
    [Fabric with:@[[Crashlytics class]]];
}

+ (void)setupGlobalUIChanges {
    // UINavigationBar
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[[RNThemeManager sharedManager] colorForKey:kELDarkVioletColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:18.0],
                                                           NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

+ (void)setupIQKeyboardManager {
    IQKeyboardManager *keyboardManager;
    
    keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.enableAutoToolbar = NO;
    keyboardManager.keyboardDistanceFromTextField = 10;
    keyboardManager.shouldResignOnTouchOutside = YES;
}

@end
