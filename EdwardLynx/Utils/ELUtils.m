//
//  ELUtils.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELUtils.h"

#import "ELBaseQuestionTypeView.h"
#import "ELQuestionTypeAgreementView.h"
#import "ELQuestionTypeScaleView.h"
#import "ELQuestionTypeTextView.h"

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

@interface ELUtils ()

@property (nonatomic, strong) NSString *firebaseToken;

@end

@implementation ELUtils

#pragma mark - User Defaults Helper Methods

+ (id)getUserDefaultsCustomObjectForKey:(NSString *)key {
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    __kindof NSObject *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    return object;
}

+ (id)getUserDefaultsObjectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (id)getUserDefaultsValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (void)setUserDefaultsCustomObject:(__kindof NSObject *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setUserDefaultsObject:(__kindof NSObject *)object key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setUserDefaultsValue:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - API Helper Methods

+ (void)processReauthenticationWithCompletion:(void (^)(NSError *error))completion {
    [[[ELUsersAPIClient alloc] init] reauthenticateWithCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completion(error);
            }
            
            [ELUtils setUserDefaultsCustomObject:[[ELOAuthInstance alloc] initWithDictionary:responseDict error:nil]
                                             key:kELAuthInstanceUserDefaultsKey];
            
            NSLog(@"%@: Credentials reauthenticated", [self class]);
            
            completion(nil);
        });
    }];
}

#pragma mark - Third-party Packages Helper Methods

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

#pragma mark - Third-party Packages Setup Helper Methods

+ (void)setupFabric {
    [Fabric with:@[[Crashlytics class]]];
}

+ (void)setupIQKeyboardManager {
    IQKeyboardManager *keyboardManager;
    
    keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.enableAutoToolbar = NO;
    keyboardManager.keyboardDistanceFromTextField = 10;
    keyboardManager.shouldResignOnTouchOutside = YES;
}

#pragma mark - App-related Helper Methods

+ (void)setupGlobalUIChanges {
    // UINavigationBar
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[[RNThemeManager sharedManager] colorForKey:kELDarkVioletColor]];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0],
                                                           NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
}

+ (void)styleSearchBar:(UISearchBar *)searchBar {
    searchBar.tintColor = [[RNThemeManager sharedManager] colorForKey:kELVioletColor];
    
    // Text Field
    UITextField *searchTextField = [searchBar valueForKey:@"_searchField"];
    UIFont *font = [UIFont fontWithName:@"Lato-Regular" size:16];
    
    [searchTextField setFont:font];
    [searchTextField setTextColor:[UIColor whiteColor]];
    [searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [searchTextField setMinimumFontSize:12];
    [searchTextField setBounds:CGRectMake(0, 0, CGRectGetWidth(searchTextField.frame), 40)];
    
    // Cancel Button
    id barButtonAppearanceInSearchBar = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]];
    
    [barButtonAppearanceInSearchBar setTitle:@"Cancel"];
    [barButtonAppearanceInSearchBar setTitleTextAttributes:@{NSFontAttributeName: font,
                                                             NSForegroundColorAttributeName: [UIColor whiteColor]}
                                                  forState:UIControlStateNormal];
}

+ (__kindof ELBaseQuestionTypeView *)viewByAnswerType:(kELAnswerType)type {
    switch (type) {
        case kELAnswerTypeOneToFiveScale:
            return [[ELQuestionTypeScaleView alloc] initWithFormKey:@"sample"];
        case kELAnswerTypeOneToTenScale:
            return [[ELQuestionTypeScaleView alloc] initWithFormKey:@"sample"];
        case kELAnswerTypeAgreeementScale:
            return [[ELQuestionTypeAgreementView alloc] initWithFormKey:@"sample"];
        case kELAnswerTypeYesNoScale:
            return [[ELQuestionTypeScaleView alloc] initWithFormKey:@"sample"];
        case kELAnswerTypeStrongAgreeementScale:
            return [[ELQuestionTypeAgreementView alloc] initWithFormKey:@"sample"];
        case kELAnswerTypeText:
            return [[ELQuestionTypeTextView alloc] initWithFormKey:@"sample"];
        case kELAnswerTypeInvertedAgreementScale:
            return [[ELQuestionTypeAgreementView alloc] initWithFormKey:@"sample"];
        case kELAnswerTypeOneToTenWithExplanation:
            return nil;  // TEMP Should be view corresponding to answer type
        case kELAnswerTypeCustomScale:
            return [[ELQuestionTypeScaleView alloc] initWithFormKey:@"sample"];
        default:
            return nil;
    }
}

@end
