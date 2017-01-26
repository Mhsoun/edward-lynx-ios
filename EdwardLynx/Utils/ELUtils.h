//
//  ELUtils.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <Crashlytics/Crashlytics.h>
#import <DYSlideView/DYSlideView.h>
#import <Fabric/Fabric.h>
#import <Firebase/Firebase.h>
#import <FirebaseMessaging/FirebaseMessaging.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

#import "AppDelegate.h"
#import "ELUsersAPIClient.h"

@class ELBaseQuestionTypeView;

@interface ELFormItemGroup : NSObject

- (instancetype)initWithInput:(__kindof UIView<UITextInput> *)textField
                         icon:(UIImageView *)icon
                   errorLabel:(UILabel *)errorLabel;

- (instancetype)initWithText:(NSString *)text
                        icon:(UIImageView *)icon
                  errorLabel:(UILabel *)errorLabel;

- (NSString *)textValue;
- (void)toggleValidationIndicatorsBasedOnErrors:(NSArray *)errors;

@end

@interface ELUtils : NSObject

+ (id)getUserDefaultsCustomObjectForKey:(NSString *)key;
+ (id)getUserDefaultsObjectForKey:(NSString *)key;
+ (id)getUserDefaultsValueForKey:(NSString *)key;
+ (void)setUserDefaultsCustomObject:(__kindof NSObject *)object
                                key:(NSString *)key;
+ (void)setUserDefaultsObject:(__kindof NSObject *)object
                          key:(NSString *)key;
+ (void)setUserDefaultsValue:(id)value
                         key:(NSString *)key;

+ (void)processReauthenticationWithCompletion:(void (^)(NSError *error))completion;

+ (void)fabricForceCrash;
+ (void)fabricLogUserInformation:(NSDictionary *)infoDict;

+ (void)setupFabric;
+ (void)setupIQKeyboardManager;

+ (void)animateCell:(__kindof UITableViewCell *)cell;
+ (kELAnswerType)answerTypeByLabel:(NSString *)label;
+ (NSString *)labelByAnswerType:(kELAnswerType)type;
+ (NSString *)labelByListFilter:(kELListFilter)filter;
+ (NSString *)labelByReportType:(kELReportType)type;
+ (NSString *)labelBySurveyStatus:(kELSurveyStatus)status;
+ (__kindof ELBaseQuestionTypeView *)questionViewFromSuperview:(UIView *)view;
+ (void)presentToastAtView:(UIView *)view
                   message:(NSString *)message
                completion:(void (^)())completion;
+ (void)setupGlobalUIChanges;
+ (void)setupSlideView:(DYSlideView *)slideView;
+ (BOOL)toggleQuestionTypeViewExpansionByType:(kELAnswerType)type;
+ (__kindof ELBaseQuestionTypeView *)viewByAnswerType:(kELAnswerType)type;

@end
