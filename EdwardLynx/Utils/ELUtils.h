//
//  ELUtils.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

@class ELBaseQuestionTypeView;
@class ELDevelopmentPlan;
@class ELListPopupViewController;
@class ELPopupViewController;
@class PNCircleChart;

#import <MessageUI/MessageUI.h>

#import "ELQuestion.h"

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

+ (void)processReauthenticationWithCompletion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;

+ (void)fabricForceCrash;
+ (void)fabricLogUserInformation:(NSDictionary *)infoDict;

+ (void)setupFabric;
+ (void)setupHockeyApp;
+ (void)setupIQKeyboardManager;

+ (void)animateCell:(__kindof UITableViewCell *)cell;
+ (kELAnswerType)answerTypeByLabel:(NSString *)label;
+ (void)circleChart:(PNCircleChart *)chart progress:(CGFloat)progress;
+ (void)composeMailForController:(__kindof UIViewController *)controller
                         details:(NSDictionary *)detailsDict;
+ (void)displayPopupForViewController:(__kindof UIViewController *)controller
                                 type:(kELPopupType)type
                              details:(NSDictionary *)detailsDict;
+ (void)handleMailResult:(MFMailComposeResult)result
    fromParentController:(__kindof UIViewController *)controller;
+ (NSString *)labelByAnswerType:(kELAnswerType)type;
+ (NSString *)labelByListFilter:(kELListFilter)filter;
+ (NSString *)labelBySurveyStatus:(kELSurveyStatus)status;
+ (NSString *)labelBySurveyType:(kELSurveyType)type;
+ (NSString *)labelByUserRole:(kELUserRole)role;
+ (UIAlertController *)loadingAlert;
+ (NSArray *)orderedReportKeysArray:(NSArray *)keys;
+ (void)PDFDownloadFromLink:(NSString *)link filename:(NSString *)filename;
+ (NSURLRequest *)PDFViewRequestFromPath:(NSString *)path;
+ (void)presentToastAtView:(UIView *)view
                   message:(NSString *)message
                completion:(void (^)())completion;
+ (ELQuestion *)questionTemplateForAnswerType:(kELAnswerType)answerType;
+ (__kindof ELBaseQuestionTypeView *)questionViewFromSuperview:(UIView *)view;
+ (void)registerValidators;
+ (NSArray *)removeDuplicateUsers:(NSArray *)subset
                         superset:(NSArray *)superset;
+ (void)scrollViewToBottom:(UIScrollView *)scrollView;
+ (void)setupGlobalUIChanges;
+ (BOOL)toggleQuestionTypeViewExpansionByType:(kELAnswerType)type;
+ (kELUserRole)userRoleByLabel:(NSString *)label;
+ (__kindof ELBaseQuestionTypeView *)viewByAnswerType:(kELAnswerType)type;

@end
