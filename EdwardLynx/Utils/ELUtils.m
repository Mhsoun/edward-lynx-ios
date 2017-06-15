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
#import <HockeySDK/HockeySDK.h>
#import <PNChart/PNCircleChart.h>
#import <REValidation/REValidation.h>
#import <UIView+Toast.h>

#import "ELUtils.h"
#import "AppDelegate.h"
#import "ELBaseQuestionTypeView.h"
#import "ELDevelopmentPlan.h"
#import "ELEmailValidator.h"
#import "ELListPopupViewController.h"
#import "ELOAuthInstance.h"
#import "ELParticipant.h"
#import "ELPopupViewController.h"
#import "ELQuestionTypeAgreementView.h"
#import "ELQuestionTypeRadioGroupView.h"
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
    [self.icon setTintColor:ThemeColor(isValid ? kELDarkGrayColor : kELRedColor)];
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

+ (void)setupHockeyApp {
    NSString *appId = [[[NSBundle mainBundle] objectForInfoDictionaryKey:kELHockeyAppPlistKey] objectForKey:kELAppIdPlistKey];
    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:appId];
    [[BITHockeyManager sharedHockeyManager].crashManager setCrashManagerStatus:BITCrashManagerStatusAutoSend];
    [[BITHockeyManager sharedHockeyManager] startManager];
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
    animation.values =  @[@0, @20, @(-20), @10, @0];
    animation.keyTimes = @[@0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.additive = YES;
    
    [cell.layer addAnimation:animation forKey:@"shake"];
}

+ (kELAnswerType)answerTypeByLabel:(NSString *)label {
    if ([label isEqualToString:NSLocalizedString(@"kELFeedbackAnswerTypeOneToFiveScale", nil)]) {
        return kELAnswerTypeOneToFiveScale;
    } else if ([label isEqualToString:NSLocalizedString(@"kELFeedbackAnswerTypeOneToTenScale", nil)]) {
        return kELAnswerTypeOneToTenScale;
    } else if ([label isEqualToString:NSLocalizedString(@"kELFeedbackAnswerTypeAgreementScale", nil)]) {
        return kELAnswerTypeAgreeementScale;
    } else if ([label isEqualToString:NSLocalizedString(@"kELFeedbackAnswerTypeYesNoScale", nil)]) {
        return kELAnswerTypeYesNoScale;
    } else if ([label isEqualToString:NSLocalizedString(@"kELFeedbackAnswerTypeStrongAgreementScale", nil)]) {
        return kELAnswerTypeStrongAgreeementScale;
    } else if ([label isEqualToString:NSLocalizedString(@"kELFeedbackAnswerTypeText", nil)]) {
        return kELAnswerTypeText;
    } else if ([label isEqualToString:NSLocalizedString(@"kELFeedbackAnswerTypeInvertedAgreementScale", nil)]) {
        return kELAnswerTypeInvertedAgreementScale;
    } else if ([label isEqualToString:NSLocalizedString(@"kELFeedbackAnswerTypeOneToTenWithExplanation", nil)]) {
        return kELAnswerTypeOneToTenWithExplanation;
    } else if ([label isEqualToString:NSLocalizedString(@"kELFeedbackAnswerTypeCustomScale", nil)]) {
        return kELAnswerTypeCustomScale;
    } else {
        return -1;
    }
}

+ (void)circleChart:(PNCircleChart *)chart developmentPlan:(ELDevelopmentPlan *)developmentPlan {
    chart.backgroundColor = [UIColor clearColor];
    chart.strokeColor = ThemeColor(kELOrangeColor);
    chart.current = [NSNumber numberWithFloat:(developmentPlan.progress * 100)];
    
    chart.countingLabel.font = Font(@"Lato-Bold", 20.0f);
    chart.countingLabel.textColor = [UIColor whiteColor];
}

+ (void)displayPopupForViewController:(__kindof UIViewController *)controller
                                 type:(kELPopupType)type
                              details:(NSDictionary *)detailsDict {
    ELPopupViewController *popup;
    ELListPopupViewController *listPopup;
    CGPoint offset = CGPointMake(0, -50);
    
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
            listPopup.popupViewOffset = offset;
            
            if (detailsDict[@"delegate"]) {
                listPopup.delegate = detailsDict[@"delegate"];
            } else {
                listPopup.delegate = controller;
            }
            
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
            return NSLocalizedString(@"kELListFilterAll", nil);
            
            break;
        case kELListFilterInProgress:
            return NSLocalizedString(@"kELListFilterInProgress", nil);
            
            break;
        case kELListFilterCompleted:
            return NSLocalizedString(@"kELListFilterCompleted", nil);
            
            break;
        case kELListFilterExpired:
            return NSLocalizedString(@"kELListFilterExpired", nil);
            
            break;
        case kELListFilterInstantFeedback:
            return NSLocalizedString(@"kELListFilterInstantFeedback", nil);
            
            break;
        case kELListFilterLynxMeasurement:
            return NSLocalizedString(@"kELListFilterLynxMeasurement", nil);
            
            break;
        default:
            return @"";
            
            break;
    }
}

+ (NSString *)labelBySurveyStatus:(kELSurveyStatus)status {
    switch (status) {
        case kELSurveyStatusOpen:
            return NSLocalizedString(@"kELSurveyStatusOpen", nil);
            
            break;
        case kELSurveyStatusUnfinished:
            return NSLocalizedString(@"kELSurveyStatusUnfinished", nil);
            
            break;
        case kELSurveyStatusCompleted:
            return NSLocalizedString(@"kELSurveyStatusCompleted", nil);
            
            break;
        case kELSurveyStatusNotInvited:
            return NSLocalizedString(@"kELSurveyStatusNotInvited", nil);
            
            break;
        default:
            return @"";
            
            break;
    }
}

+ (NSString *)labelBySurveyType:(kELSurveyType)type {
    switch (type) {
        case kELSurveyType360Individual:
            return NSLocalizedString(@"kELSurveyType360Individual", nil);
            
            break;
        case kELSurveyTypeLMTT:
            return NSLocalizedString(@"kELSurveyTypeLMTT", nil);
            
            break;
        case kELSurveyTypeProgress:
            return NSLocalizedString(@"kELSurveyTypeProgress", nil);
            
            break;
        case kELSurveyTypeSurvey:
            return NSLocalizedString(@"kELSurveyTypeSurvey", nil);
            
            break;
        case kELSurveyTypeLTT:
            return NSLocalizedString(@"kELSurveyTypeLTT", nil);
            
            break;
        default:
            return @"";
            
            break;
    }
}

+ (NSString *)labelByUserRole:(kELUserRole)role {
    switch (role) {
        case kELUserRoleColleague:
            return NSLocalizedString(@"kELUserRoleColleague", nil);
        case kELUserRoleManager:
            return NSLocalizedString(@"kELUserRoleManager", nil);
        case kELUserRoleCustomer:
            return NSLocalizedString(@"kELUserRoleCustomer", nil);
        case kELUserRoleMatrixManager:
            return NSLocalizedString(@"kELUserRoleMatrixManager", nil);
        case kELUserRoleOtherStakeholder:
            return NSLocalizedString(@"kELUserRoleOtherStakeholder", nil);
        case kELUserRoleDirectReport:
            return NSLocalizedString(@"kELUserRoleDirectReport", nil);
        default:
            return @"";
    }
}

+ (UIAlertController *)loadingAlert {
    return AppSingleton.loadingAlert;
}

+ (NSArray *)orderedReportKeysArray:(NSArray *)keys {
    NSMutableArray *mOrderedKeys = [[NSMutableArray alloc] init];
    
    if ([keys containsObject:@"response_rate"]) {
        [mOrderedKeys addObject:@"response_rate"];
    }
    
    if ([keys containsObject:@"radar_diagram"]) {
        [mOrderedKeys addObject:@"radar_diagram"];
    }
    
    if ([keys containsObject:@"comments"]) {
        [mOrderedKeys addObject:@"comments"];
    }
    
    if ([keys containsObject:@"highestLowestIndividual.highest.Manager"]) {
        [mOrderedKeys addObject:@"highestLowestIndividual.highest.Manager"];
    }
    
    if ([keys containsObject:@"highestLowestIndividual.lowest.Manager"]) {
        [mOrderedKeys addObject:@"highestLowestIndividual.lowest.Manager"];
    }
    
    if ([keys containsObject:@"highestLowestIndividual.highest.Others combined"]) {
        [mOrderedKeys addObject:@"highestLowestIndividual.highest.Others combined"];
    }
    
    if ([keys containsObject:@"highestLowestIndividual.lowest.Others combined"]) {
        [mOrderedKeys addObject:@"highestLowestIndividual.lowest.Others combined"];
    }
    
    if ([keys containsObject:@"blindspot.overestimated"]) {
        [mOrderedKeys addObject:@"blindspot.overestimated"];
    }
    
    if ([keys containsObject:@"blindspot.underestimated"]) {
        [mOrderedKeys addObject:@"blindspot.underestimated"];
    }
    
    if ([keys containsObject:@"breakdown"]) {
        [mOrderedKeys addObject:@"breakdown"];
    }
    
    if ([keys containsObject:@"detailed_answer_summary"]) {
        [mOrderedKeys addObject:@"detailed_answer_summary"];
    }
    
    if ([keys containsObject:@"yes_or_no"]) {
        [mOrderedKeys addObject:@"yes_or_no"];
    }
    
    return [mOrderedKeys copy];
}

+ (void)presentToastAtView:(UIView *)view
                   message:(NSString *)message
                completion:(void (^)())completion {
    NSTimeInterval duration = 1.5;
    
    [view makeToast:message duration:duration position:CSToastPositionBottom];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((duration + 0.5) * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        if (completion) {
            completion();
        }
    });
}

+ (ELQuestion *)questionTemplateForAnswerType:(kELAnswerType)answerType {
    NSDictionary *answerDict;
    
    switch (answerType) {
        case kELAnswerTypeYesNoScale:
            answerDict = @{@"type": @(answerType),
                           @"isText": @NO,
                           @"isNumeric": @NO,
                           @"help": @"",
                           @"options": @[@{@"value": @0, @"description": @"No"},
                                         @{@"value": @1, @"description": @"Yes"}]};
            
            return [[ELQuestion alloc] initWithDictionary:@{@"id": @(-1),
                                                            @"optional": @NO,
                                                            @"isNA": @NO,
                                                            @"isFollowUpQuestion": @NO,
                                                            @"text": @"Question Preview",
                                                            @"answer": answerDict}
                                                    error:nil];
            break;
        case kELAnswerTypeText:
            answerDict = @{@"type": @(answerType),
                           @"isText": @YES,
                           @"isNumeric": @NO,
                           @"help": @""};
            
            return [[ELQuestion alloc] initWithDictionary:@{@"id": @(-1),
                                                            @"optional": @NO,
                                                            @"isNA": @NO,
                                                            @"isFollowUpQuestion": @NO,
                                                            @"text": @"Question Preview",
                                                            @"answer": answerDict}
                                                    error:nil];
            break;
        case kELAnswerTypeOneToTenScale:
            answerDict = @{@"type": @(answerType),
                           @"isText": @NO,
                           @"isNumeric": @YES,
                           @"help": @"",
                           @"options": @[@{@"value": @0, @"description": @"1"},
                                         @{@"value": @1, @"description": @"2"},
                                         @{@"value": @2, @"description": @"3"},
                                         @{@"value": @3, @"description": @"4"},
                                         @{@"value": @4, @"description": @"5"},
                                         @{@"value": @5, @"description": @"6"},
                                         @{@"value": @6, @"description": @"7"},
                                         @{@"value": @7, @"description": @"8"},
                                         @{@"value": @8, @"description": @"9"},
                                         @{@"value": @9, @"description": @"10"}]};
            
            return [[ELQuestion alloc] initWithDictionary:@{@"id": @(-1),
                                                            @"optional": @NO,
                                                            @"isNA": @NO,
                                                            @"isFollowUpQuestion": @NO,
                                                            @"text": @"Question Preview",
                                                            @"answer": answerDict}
                                                    error:nil];
            break;
        case kELAnswerTypeCustomScale:
            answerDict = @{@"type": @(answerType),
                           @"isText": @NO,
                           @"isNumeric": @NO,
                           @"help": @""};
            
            return [[ELQuestion alloc] initWithDictionary:@{@"id": @(-1),
                                                            @"optional": @NO,
                                                            @"isNA": @NO,
                                                            @"isFollowUpQuestion": @NO,
                                                            @"text": @"Question Preview",
                                                            @"answer": answerDict}
                                                    error:nil];
            break;
        default:
            return nil;
            break;
    }
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
    [REValidation setErrorMessages:AppSingleton.validationDict];
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
    [[UINavigationBar appearance] setBarTintColor:ThemeColor(kELHeaderColor)];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: Font(@"HelveticaNeue-Bold", 14.0f),
                                                           NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    // Search Bar
    [[UISearchBar appearance] setBarTintColor:ThemeColor(kELHeaderColor)];
    
    // Table View cell
    [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];
}

+ (BOOL)toggleQuestionTypeViewExpansionByType:(kELAnswerType)type {
    NSArray *answerTypes = @[@(kELAnswerTypeYesNoScale), @(kELAnswerTypeCustomScale),
                             @(kELAnswerTypeOneToFiveScale), @(kELAnswerTypeOneToTenScale),
                             @(kELAnswerTypeAgreeementScale), @(kELAnswerTypeStrongAgreeementScale),
                             @(kELAnswerTypeInvertedAgreementScale)];
    
    return [answerTypes containsObject:@(type)];
}

+ (kELUserRole)userRoleByLabel:(NSString *)label {
    if ([label isEqualToString:NSLocalizedString(@"kELUserRoleColleague", nil)]) {
        return kELUserRoleColleague;
    } else if ([label isEqualToString:NSLocalizedString(@"kELUserRoleManager", nil)]) {
        return kELUserRoleManager;
    } else if ([label isEqualToString:NSLocalizedString(@"kELUserRoleCustomer", nil)]) {
        return kELUserRoleCustomer;
    } else if ([label isEqualToString:NSLocalizedString(@"kELUserRoleMatrixManager", nil)]) {
        return kELUserRoleMatrixManager;
    } else if ([label isEqualToString:NSLocalizedString(@"kELUserRoleOtherStakeholder", nil)]) {
        return kELUserRoleOtherStakeholder;
    } else if ([label isEqualToString:NSLocalizedString(@"kELUserRoleDirectReport", nil)]) {
        return kELUserRoleDirectReport;
    } else {
        return -1;
    }
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
                                                            [[ELQuestionTypeRadioGroupView alloc] init];
        case kELAnswerTypeYesNoScale:
            return [objectType isEqualToString:@"string"] ? NSLocalizedString(@"kELFeedbackAnswerTypeYesNoScale", nil) :
                                                            [[ELQuestionTypeRadioGroupView alloc] init];
        case kELAnswerTypeStrongAgreeementScale:
            return [objectType isEqualToString:@"string"] ? NSLocalizedString(@"kELFeedbackAnswerTypeStrongAgreementScale", nil) :
                                                            [[ELQuestionTypeRadioGroupView alloc] init];
        case kELAnswerTypeText:
            return [objectType isEqualToString:@"string"] ? NSLocalizedString(@"kELFeedbackAnswerTypeText", nil) :
                                                            [[ELQuestionTypeTextView alloc] init];
        case kELAnswerTypeInvertedAgreementScale:
            return [objectType isEqualToString:@"string"] ? NSLocalizedString(@"kELFeedbackAnswerTypeInvertedAgreementScale", nil) :
                                                            [[ELQuestionTypeRadioGroupView alloc] init];
        case kELAnswerTypeOneToTenWithExplanation:
            return [objectType isEqualToString:@"string"] ? NSLocalizedString(@"kELFeedbackAnswerTypeOneToTenWithExplanation", nil) :
                                                            [[ELQuestionTypeScaleView alloc] init];
        case kELAnswerTypeCustomScale:
            return [objectType isEqualToString:@"string"] ? NSLocalizedString(@"kELFeedbackAnswerTypeCustomScale", nil) :
                                                            [[ELQuestionTypeRadioGroupView alloc] init];
        default:
            return nil;
    }
}

@end
