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
    
    // Label
    self.errorLabel.text = !isValid ? [errors[0] localizedDescription] : @"";
    self.errorLabel.hidden = isValid;
    
    // Icon
    [self.icon setImage:[self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.icon setTintColor:isValid ? [[RNThemeManager sharedManager] colorForKey:kELDarkGrayColor] :
                                      [UIColor redColor]];
}

@end

@implementation ELUtils

+ (void)fabricForceCrash {
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

+ (id)getUserDefaultValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

#pragma mark - Third-party Packages Setup

+ (void)setupFabric {
    [Fabric with:@[[Crashlytics class]]];
}

+ (void)setupGlobalUIChanges {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:18.0],
                                                           NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UINavigationBar appearance] setBarTintColor:[[RNThemeManager sharedManager] colorForKey:kELDarkVioletColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
}

+ (void)setupIQKeyboardManager {
    IQKeyboardManager *keyboardManager;
    
    keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.enableAutoToolbar = YES;
    keyboardManager.keyboardDistanceFromTextField = 10;
    keyboardManager.shouldResignOnTouchOutside = YES;
}

@end
