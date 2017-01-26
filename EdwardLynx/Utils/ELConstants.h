//
//  ELConstants.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 07/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#ifndef ELConstants_h
#define ELConstants_h

#pragma mark - Macros

#ifdef DEBUG
    #define DLog(...) NSLog(__VA_ARGS__)
#else
    #define DLog(...)
#endif

#define IDIOM UI_USER_INTERFACE_IDIOM()
#define IPAD UIUserInterfaceIdiomPad
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#pragma mark - Enums

typedef NS_ENUM(NSInteger, kELAnswerType) {
    kELAnswerTypeOneToFiveScale = 0,
    kELAnswerTypeOneToTenScale = 1,
    kELAnswerTypeAgreeementScale = 2,
    kELAnswerTypeYesNoScale = 3,
    kELAnswerTypeStrongAgreeementScale = 4,
    kELAnswerTypeText = 5,
    kELAnswerTypeInvertedAgreementScale = 6,
    kELAnswerTypeOneToTenWithExplanation = 7,
    kELAnswerTypeCustomScale = 8
};

typedef NS_ENUM(NSInteger, kELInviteUsers) {
    kELInviteUsersInstantFeedback,
    kELInviteUsersReports
};

typedef NS_ENUM(NSInteger, kELListFilter) {
    kELListFilterAll = 5,
    kELListFilterUnfinished = 1,
    kELListFilterComplete = 2
};

typedef NS_ENUM(NSInteger, kELReportType) {
    kELReportType360,
    kELReportTypeInstant
};

typedef NS_ENUM(NSInteger, kELRolePermission) {
    kELRolePermissionParticipateInSurvey,
    kELRolePermissionSelectFeedbackProviders,
    kELRolePermissionSubmitSurvey,
    kELRolePermissionManage,
    kELRolePermissionViewAnonymousIndividualReports,
    kELRolePermissionViewAnonymousTeamReports,
    kELRolePermissionCreateDevelopmentPlan,
    kELRolePermissionCreateGoals,
    kELRolePermissionInstantFeedback
};

typedef NS_ENUM(NSInteger, kELSurveyStatus) {
    kELSurveyStatusOpen = 0,
    kELSurveyStatusPartial = 1,
    kELSurveyStatusComplete = 2,
    kELSurveyStatusNotInvited = 3
};

#pragma mark - .plist Keys (Root)

extern NSString * const kELAPIClientPlistKey;
extern NSString * const kELFabricPlistKey;
extern NSString * const kELHockeyAppPlistKey;

#pragma mark - .plist Keys (Dictionary Keys)

extern NSString * const kELAPITokenPlistKey;

#pragma mark - Alert Messages

extern NSString * const kELDefaultAlertMessage;
extern NSString * const kELLogoutAlertMessage;

#pragma mark - Constants

extern NSString * const kELEdwardLynxContactUsURL;

extern NSString * const kELErrorDomain;

extern NSString * const kELFabricEmail;
extern NSString * const kELFabricIdentifier;
extern NSString * const kELFabricUsername;

extern NSString * const kELLanguageCodeEnglish;
extern NSString * const kELLanguageCodeFinnish;
extern NSString * const kELLanguageCodeSwedish;

extern CGFloat const kELQuestionTypeDefaultHeight;
extern CGFloat const kELQuestionTypeExpandedHeight;

extern NSString * const kELUserRoleAdmin;
extern NSString * const kELUserRoleAnalyst;
extern NSString * const kELUserRoleFeedbackProvider;
extern NSString * const kELUserRoleParticipant;
extern NSString * const kELUserRoleSuperAdmin;
extern NSString * const kELUserRoleSupervisor;

#pragma mark - Endpoints

extern NSString * const kELAPIVersionNamespace;
extern NSString * const kELAPIRootEndpoint;
extern NSString * const kELAPIInstantFeedbacksEndpoint;
extern NSString * const kELAPIInstantFeedbackEndpoint;
extern NSString * const kELAPIInstantFeedbackAnswersEndpoint;
extern NSString * const kELAPIInstantFeedbackSharesEndpoint;
extern NSString * const kELAPIQuestionCategoriesEndpoint;
extern NSString * const kELAPIQuestionCategoryEndpoint;
extern NSString * const kELAPIQuestionsEndpoint;
extern NSString * const kELAPIQuestionEndpoint;
extern NSString * const kELAPISurveysEndpoint;
extern NSString * const kELAPISurveyEndpoint;
extern NSString * const kELAPISurveyAnswersEndpoint;
extern NSString * const kELAPISurveyQuestionsEndpoint;
extern NSString * const kELAPIUserEndpoint;
extern NSString * const kELAPIUsersEndpoint;
extern NSString * const kELAPILoginEndpoint;

#pragma mark - HTTP Methods

extern NSString * const kELAPIDeleteHTTPMethod;
extern NSString * const kELAPIGetHTTPMethod;
extern NSString * const kELAPIPatchHTTPMethod;
extern NSString * const kELAPIPostHTTPMethod;
extern NSString * const kELAPIPutHTTPMethod;

#pragma mark - NSUserDefaults Keys

extern NSString * const kELAuthInstanceUserDefaultsKey;
extern NSString * const kELAuthCredentialsUserDefaultsKey;

#pragma mark - RNThemeManager .plist Keys

extern NSString * const kELBlackColor;
extern NSString * const kELWhiteColor;
extern NSString * const kELGreenColor;
extern NSString * const kELLightGrayColor;
extern NSString * const kELGrayColor;
extern NSString * const kELDarkGrayColor;
extern NSString * const kELLightVioletColor;
extern NSString * const kELVioletColor;
extern NSString * const kELDarkVioletColor;

#pragma mark - Status Codes

extern NSInteger const kELAPIOKStatusCode;
extern NSInteger const kELAPICreatedStatusCode;
extern NSInteger const kELAPINoContentStatusCode;
extern NSInteger const kELAPIBadRequestStatusCode;
extern NSInteger const kELAPIUnauthorizedStatusCode;
extern NSInteger const kELAPINotFoundStatusCode;

#endif /* ELConstants_h */
