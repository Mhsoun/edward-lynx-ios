//
//  ELUtils.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <Crashlytics/Crashlytics.h>
#import <Fabric/Fabric.h>
#import <Firebase/Firebase.h>
#import <FirebaseMessaging/FirebaseMessaging.h>
#import <REValidation/REValidation.h>
#import <UIView+Toast.h>

#import "ELUtils.h"
#import "AppDelegate.h"
#import "ELBaseQuestionTypeView.h"
#import "ELEmailValidator.h"
#import "ELListPopupViewController.h"
#import "ELOAuthInstance.h"
#import "ELParticipant.h"
#import "ELPopupViewController.h"
#import "ELQuestionTypeAgreementView.h"
#import "ELQuestionTypeScaleView.h"
#import "ELQuestionTypeTextView.h"
#import "ELUsersAPIClient.h"

@interface ELFormItemGroup ()

@property (nonatomic, strong) __kindof UITextField *textField;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *errorLabel;

@end

@implementation ELFormItemGroup

- (instancetype)initWithInput:(__kindof UIView<UITextInput> *)textField
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

- (instancetype)initWithText:(NSString *)text
                        icon:(UIImageView *)icon
                  errorLabel:(UILabel *)errorLabel {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _text = text;
    _icon = icon;
    _errorLabel = errorLabel;
    
    return self;
}

- (NSString *)textValue {
    return !self.textField ? self.text : self.textField.text;
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

+ (void)setUserDefaultsValue:(id)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - API Helper Methods

+ (void)processReauthenticationWithCompletion:(void (^)(NSError *error))completion {
    [[[ELUsersAPIClient alloc] init] reauthenticateWithCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completion(error);
                
                return;
            }
            
            [ELUtils setUserDefaultsCustomObject:[[ELOAuthInstance alloc] initWithDictionary:responseDict error:nil]
                                             key:kELAuthInstanceUserDefaultsKey];
            
            DLog(@"%@: Credentials reauthenticated", [self class]);
            
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

+ (void)animateCell:(__kindof UITableViewCell *)cell {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    
    animation.keyPath = @"position.x";
    animation.values =  @[@0, @20, @-20, @10, @0];
    animation.keyTimes = @[@0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.additive = YES;
    
    [cell.layer addAnimation:animation forKey:@"shake"];
}

+ (kELAnswerType)answerTypeByLabel:(NSString *)label {
    if ([label isEqualToString:@"Numeric 1-5 Scale"]) {
        return kELAnswerTypeOneToFiveScale;
    } else if ([label isEqualToString:@"Numeric 1-10 Scale"]) {
        return kELAnswerTypeOneToTenScale;
    } else if ([label isEqualToString:@"Agreement Scale"]) {
        return kELAnswerTypeAgreeementScale;
    } else if ([label isEqualToString:@"Yes/No Scale"]) {
        return kELAnswerTypeYesNoScale;
    } else if ([label isEqualToString:@"Strong Agreement Scale"]) {
        return kELAnswerTypeStrongAgreeementScale;
    } else if ([label isEqualToString:@"Text"]) {
        return kELAnswerTypeText;
    } else if ([label isEqualToString:@"Inverted Agreement Scale"]) {
        return kELAnswerTypeInvertedAgreementScale;
    } else if ([label isEqualToString:@"1-10 with explanation"]) {
        return kELAnswerTypeOneToTenWithExplanation;
    } else if ([label isEqualToString:@"Custom Scale"]) {
        return kELAnswerTypeCustomScale;
    } else {
        return -1;
    }
}

+ (void)displayPopupForViewController:(__kindof UIViewController *)controller
                                 type:(kELPopupType)type
                              details:(NSDictionary *)detailsDict {
    ELPopupViewController *popup;
    ELListPopupViewController *listPopup;
    CGPoint offset = CGPointMake(0, -100);
    
    if (controller.popupViewController) {
        return;
    }
    
    switch (type) {
        case kELPopupTypeMessage:
            popup = [[ELPopupViewController alloc] initWithPreviousController:controller details:detailsDict];
            popup.popupViewOffset = offset;
            
            [controller presentPopupViewController:popup
                                          animated:YES
                                        completion:nil];
            
            break;
        case kELPopupTypeList:
            listPopup = [[ELListPopupViewController alloc] initWithPreviousController:controller details:detailsDict];
            listPopup.delegate = controller;
            listPopup.popupViewOffset = offset;
            
            [controller presentPopupViewController:listPopup
                                          animated:YES
                                        completion:nil];
            
            break;
        default:
            break;
    }
    
}

+ (NSString *)labelByAnswerType:(kELAnswerType)type {
    return [[self class] object:@"string" byAnswerType:type];
}

+ (NSString *)labelByListFilter:(kELListFilter)filter {
    switch (filter) {
        case kELListFilterAll:
            return @"All";
            
            break;
        case kELListFilterUnfinished:
            return @"Unfinished";
            
            break;
        case kELListFilterComplete:
            return @"Completed";
            
            break;
        default:
            break;
    }
}

+ (NSString *)labelByReportType:(kELReportType)type {
    switch (type) {
        case kELReportType360:
            return @"360 Reports";
            
            break;
        case kELReportTypeInstant:
            return @"Instant";
            
            break;
        default:
            return nil;
            
            break;
    }
}

+ (NSString *)labelBySurveyStatus:(kELSurveyStatus)status {
    switch (status) {
        case kELSurveyStatusOpen:
            return @"Open";
            
            break;
        case kELSurveyStatusPartial:
            return @"Partial";
            
            break;
        case kELSurveyStatusComplete:
            return @"Completed";
            
            break;
        case kELSurveyStatusNotInvited:
            return @"Not Invited";
            
            break;
        default:
            return nil;
            
            break;
    }
}

+ (void)presentToastAtView:(UIView *)view
                   message:(NSString *)message
                completion:(void (^)())completion {
    [view makeToast:message duration:3.0 position:CSToastPositionBottom];
}

+ (__kindof ELBaseQuestionTypeView *)questionViewFromSuperview:(UIView *)view {
    for (__kindof UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[ELBaseQuestionTypeView class]]) {
            return subview;
        }
    }
    
    return nil;
}

+ (void)registerValidators {
    [REValidation registerDefaultValidators];
    [REValidation registerValidator:[ELEmailValidator class]];
    [REValidation setErrorMessages:[ELAppSingleton sharedInstance].validationDict];
}

+ (NSArray *)removeDuplicateUsers:(NSArray *)subset superset:(NSArray *)superset {
    NSMutableArray *mUsers = [[NSMutableArray alloc] init];
    
    for (ELParticipant *supersetParticipant in superset) {
        for (int i = 0; i < subset.count; i++) {
            ELParticipant *subsetParticipant = subset[i];
            
            if ([subsetParticipant isEqual:supersetParticipant]) {
                break;
            }
            
            if (i == subset.count - 1 && ![mUsers containsObject:supersetParticipant]) {
                [mUsers addObject:supersetParticipant];
            }
        }
    }
    
    return [mUsers copy];
}

+ (BOOL)toggleQuestionTypeViewExpansionByType:(kELAnswerType)type {
    NSArray *answerTypes = @[@(kELAnswerTypeOneToTenWithExplanation), @(kELAnswerTypeText),
                             @(kELAnswerTypeAgreeementScale), @(kELAnswerTypeStrongAgreeementScale),
                             @(kELAnswerTypeInvertedAgreementScale)];
    
    return [answerTypes containsObject:@(type)];
}

+ (void)scrollViewToBottom:(UIScrollView *)scrollView {
    CGSize contentSize = scrollView.contentSize;
    
    [scrollView scrollRectToVisible:CGRectMake(contentSize.width - 1, contentSize.height - 1, 1, 1)
                           animated:YES];
}

+ (void)setupGlobalUIChanges {
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    
    // Toast
    style.messageFont = [UIFont fontWithName:@"Lato-Regular" size:14.0f];
    style.messageColor = [UIColor whiteColor];
    
    [CSToastManager setSharedStyle:style];
    [CSToastManager setQueueEnabled:YES];
    
    // Navigation Bar
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[[RNThemeManager sharedManager] colorForKey:kELHeaderColor]];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0],
                                                           NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    // Search Bar
    [[UISearchBar appearance] setBarTintColor:[[RNThemeManager sharedManager] colorForKey:kELHeaderColor]];
    
    // Table View cell
    [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];
}

+ (__kindof ELBaseQuestionTypeView *)viewByAnswerType:(kELAnswerType)type {
    return [[self class] object:@"view" byAnswerType:type];
}

#pragma mark - Private Methods

+ (id)object:(NSString *)objectType byAnswerType:(kELAnswerType)type {
    switch (type) {
        case kELAnswerTypeOneToFiveScale:
            return [objectType isEqualToString:@"string"] ? NSLocalizedString(@"kELFeedbackAnswerTypeOneToFiveScale", nil) :
                                                            [[ELQuestionTypeScaleView alloc] init];
        case kELAnswerTypeOneToTenScale:
            return [objectType isEqualToString:@"string"] ? NSLocalizedString(@"kELFeedbackAnswerTypeOneToTenScale", nil) :
                                                            [[ELQuestionTypeScaleView alloc] init];
        case kELAnswerTypeAgreeementScale:
            return [objectType isEqualToString:@"string"] ? NSLocalizedString(@"kELFeedbackAnswerTypeAgreementScale", nil) :
                                                            [[ELQuestionTypeAgreementView alloc] init];
        case kELAnswerTypeYesNoScale:
            return [objectType isEqualToString:@"string"] ? NSLocalizedString(@"kELFeedbackAnswerTypeYesNoScale", nil) :
                                                            [[ELQuestionTypeScaleView alloc] init];
        case kELAnswerTypeStrongAgreeementScale:
            return [objectType isEqualToString:@"string"] ? NSLocalizedString(@"kELFeedbackAnswerTypeStrongAgreementScale", nil) :
                                                            [[ELQuestionTypeAgreementView alloc] init];
        case kELAnswerTypeText:
            return [objectType isEqualToString:@"string"] ? NSLocalizedString(@"kELFeedbackAnswerTypeText", nil) :
                                                            [[ELQuestionTypeTextView alloc] init];
        case kELAnswerTypeInvertedAgreementScale:
            return [objectType isEqualToString:@"string"] ? NSLocalizedString(@"kELFeedbackAnswerTypeInvertedAgreementScale", nil) :
                                                            [[ELQuestionTypeAgreementView alloc] init];
        case kELAnswerTypeOneToTenWithExplanation:
            return [objectType isEqualToString:@"string"] ? NSLocalizedString(@"kELFeedbackAnswerTypeOneToTenWithExplanation", nil) :
                                                            [[ELQuestionTypeScaleView alloc] init];
        case kELAnswerTypeCustomScale:
            return [objectType isEqualToString:@"string"] ? NSLocalizedString(@"kELFeedbackAnswerTypeCustomScale", nil) :
                                                            [[ELQuestionTypeAgreementView alloc] init];
        default:
            return nil;
    }
}

@end
