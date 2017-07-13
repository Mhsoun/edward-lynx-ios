//
//  ELConstants.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 07/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "AppDelegate.h"
#import "ELAppSingleton.h"

#ifndef ELConstants_h
#define ELConstants_h

#pragma mark - Macros

#ifdef DEBUG
    #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define DLog(...)
#endif

#define Alert(alertTitle, alertMessage) [UIAlertController alertControllerWithTitle:(alertTitle) message:(alertMessage) preferredStyle:UIAlertControllerStyleAlert]
#define Application [UIApplication sharedApplication]
#define ApplicationDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define AppSingleton [ELAppSingleton sharedInstance]
#define Font(n, s) [UIFont fontWithName:(n) size:(s)]
#define Format(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]
#define UserDefaults [NSUserDefaults standardUserDefaults]
#define NotificationCenter [NSNotificationCenter defaultCenter]
#define RegisterCollectionNib(collection, n) [(collection) registerNib:[UINib nibWithNibName:(n) bundle:nil] forCellWithReuseIdentifier:(n)];
#define RegisterNib(table, n) [(table) registerNib:[UINib nibWithNibName:(n) bundle:nil] forCellReuseIdentifier:(n)];
#define SharedApplication [UIApplication sharedApplication]
#define StoryboardController(s, i) i ? [[UIStoryboard storyboardWithName:(s) bundle:nil] instantiateViewControllerWithIdentifier:(i)] : [[UIStoryboard storyboardWithName:(s) bundle:nil] instantiateInitialViewController]
#define ThemeColor(key) [[RNThemeManager sharedManager] colorForKey:(key)]

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0];
#define HEXCOLORALPHA(c, a) [UIColor colorWithRed:(((c)>>16)&0xFF)/255.0 green:(((c)>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0 alpha:(a)];
#define IDIOM UI_USER_INTERFACE_IDIOM()
#define IPAD UIUserInterfaceIdiomPad
#define RGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:a]
#define SYSTEM_VERSION_GREATERTHAN_OR_EQUALTO(v) ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedAscending)

#pragma mark - FontAwesome

#define fa_paper_plane @"\uf1d8"
#define fa_paper_plane_o @"\uf1d9"
#define fa_share_alt @"\uf1e0"
#define fa_user_circle_o @"\uf2be"
#define fa_user_plus @"\uf234"
#define fa_users @"\uf0c0"

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
    kELListFilterInProgress = 1,
    kELListFilterCompleted = 2,
    kELListFilterExpired = -1,
    kELListFilterInstantFeedback = 3,
    kELListFilterLynxMeasurement = 4
};

typedef NS_ENUM(NSInteger, kELListType) {
    kELListTypeDevPlan,
    kELListTypeReports,
    kELListTypeSurveys
};

typedef NS_ENUM(NSInteger, kELPopupType) {
    kELPopupTypeList,
    kELPopupTypeMessage
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
    kELSurveyStatusUnfinished = 1,
    kELSurveyStatusCompleted = 2,
    kELSurveyStatusNotInvited = 3
};

typedef NS_ENUM(NSInteger, kELSurveyType) {
    kELSurveyType360Individual = 0,
    kELSurveyTypeLMTT = 1,
    kELSurveyTypeProgress = 2,
    kELSurveyTypeSurvey = 3,
    kELSurveyTypeLTT = 4
};

typedef NS_ENUM(NSInteger, kELUserRole) {
    kELUserRoleColleague = 2,
    kELUserRoleManager = 3,
    kELUserRoleCustomer = 4,
    kELUserRoleMatrixManager = 5,
    kELUserRoleOtherStakeholder = 6,
    kELUserRoleDirectReport = 7
};

#pragma mark - .plist Keys (Root)

extern NSString * const kELAPIClientPlistKey;
extern NSString * const kELFabricPlistKey;
extern NSString * const kELHockeyAppPlistKey;

#pragma mark - .plist Keys (Dictionary Keys)

extern NSString * const kELAPITokenPlistKey;
extern NSString * const kELAppIdPlistKey;

#pragma mark - Constants

extern NSString * const kELAPIDateFormat;
extern NSString * const kELPrintDateFormat;

extern NSString * const kELEdwardLynxContactUsURL;

extern NSString * const kELErrorDomain;

extern NSString * const kELFabricEmail;
extern NSString * const kELFabricIdentifier;
extern NSString * const kELFabricUsername;

extern NSString * const kELLanguageCodeEnglish;
extern NSString * const kELLanguageCodeFinnish;
extern NSString * const kELLanguageCodeSwedish;

extern CGFloat const kELCustomScaleItemHeight;
extern CGFloat const kELQuestionTypeDefaultHeight;
extern CGFloat const kELQuestionTypeExpandedHeight;

extern NSInteger const kELParticipantsMinimumCount;

extern NSString * const kELUserRoleAdmin;
extern NSString * const kELUserRoleAnalyst;
extern NSString * const kELUserRoleFeedbackProvider;
extern NSString * const kELUserRoleParticipant;
extern NSString * const kELUserRoleSuperAdmin;
extern NSString * const kELUserRoleSupervisor;

#pragma mark - Email Link Paths

extern NSString * const kELAPIEmailLinkFeedback;
extern NSString * const kELAPIEmailLinkSurvey;

#pragma mark - Endpoints

extern NSString * const kELAPIVersionNamespace;
extern NSString * const kELAPIRootEndpoint;

extern NSString * const kELAPILoginEndpoint;

extern NSString * const kELAPIDevelopmentPlansEndpoint;
extern NSString * const kELAPIDevelopmentPlanEndpoint;

extern NSString * const kELAPIExchangeSurveyEndpoint;
extern NSString * const kELAPIExchangeInstantFeedbackEndpoint;

extern NSString * const kELAPIInstantFeedbacksEndpoint;
extern NSString * const kELAPIInstantFeedbackEndpoint;
extern NSString * const kELAPIInstantFeedbackAnswersEndpoint;
extern NSString * const kELAPIInstantFeedbackAddMoreParticipantsEndpoint;
extern NSString * const kELAPIInstantFeedbackSharesEndpoint;

extern NSString * const kELAPIQuestionCategoriesEndpoint;
extern NSString * const kELAPIQuestionCategoryEndpoint;
extern NSString * const kELAPIQuestionsEndpoint;
extern NSString * const kELAPIQuestionEndpoint;

extern NSString * const kELAPISurveysEndpoint;
extern NSString * const kELAPISurveyEndpoint;
extern NSString * const kELAPISurveyAnswersEndpoint;
extern NSString * const kELAPISurveyQuestionsEndpoint;
extern NSString * const kELAPISurveyRecipientsEndpoint;
extern NSString * const kELAPISurveyResultsEndpoint;

extern NSString * const kELAPITeamDevelopmentPlanEndpoint;
extern NSString * const kELAPITeamDevelopmentPlansEndpoint;
extern NSString * const kELAPITeamReportsEndpoint;
extern NSString * const kELAPITeamUsersEndpoint;

extern NSString * const kELAPIUserEndpoint;
extern NSString * const kELAPIUserDashboardEndpoint;
extern NSString * const kELAPIUserDeviceEndpoint;
extern NSString * const kELAPIUsersEndpoint;

#pragma mark - HTTP Methods

extern NSString * const kELAPIDeleteHTTPMethod;
extern NSString * const kELAPIGetHTTPMethod;
extern NSString * const kELAPIPatchHTTPMethod;
extern NSString * const kELAPIPostHTTPMethod;
extern NSString * const kELAPIPutHTTPMethod;

#pragma mark - NSNotificationCenter Names

extern NSString * const kELGoalActionAddNotification;
extern NSString * const kELGoalActionOptionsNotification;
extern NSString * const kELInstantFeedbackTabNotification;
extern NSString * const kELManagerReportDetailsNotification;
extern NSString * const kELManagerReportEmailNotification;
extern NSString * const kELPopupCloseNotification;
extern NSString * const kELTabPageSearchNotification;
extern NSString * const kELTeamChartSelectionNotification;
extern NSString * const kELTeamSeeMoreNotification;

#pragma mark - NSUserDefaults Keys

extern NSString * const kELAuthInstanceUserDefaultsKey;
extern NSString * const kELAuthCredentialsUserDefaultsKey;
extern NSString * const kELDeviceTokenUserDefaultsKey;

#pragma mark - RNThemeManager .plist Keys

extern NSString * const kELDevPlanColor;
extern NSString * const kELFeedbackColor;
extern NSString * const kELLynxColor;
extern NSString * const kELOtherColor;
extern NSString * const kELTeamColor;

extern NSString * const kELContainerColor;
extern NSString * const kELDevPlanSeparatorColor;
extern NSString * const kELHeaderColor;
extern NSString * const kELInactiveColor;
extern NSString * const kELSubtextColor;
extern NSString * const kELSurveySeparatorColor;
extern NSString * const kELTextFieldBGColor;
extern NSString * const kELTextFieldInputColor;

extern NSString * const kELBlackColor;
extern NSString * const kELBlueColor;
extern NSString * const kELDarkGrayColor;
extern NSString * const kELDarkVioletColor;
extern NSString * const kELGrayColor;
extern NSString * const kELGreenColor;
extern NSString * const kELLightGrayColor;
extern NSString * const kELLightVioletColor;
extern NSString * const kELPinkColor;
extern NSString * const kELOrangeColor;
extern NSString * const kELRedColor;
extern NSString * const kELVioletColor;
extern NSString * const kELWhiteColor;

#pragma mark - Status Codes

extern NSInteger const kELAPIOKStatusCode;
extern NSInteger const kELAPICreatedStatusCode;
extern NSInteger const kELAPINoContentStatusCode;
extern NSInteger const kELAPIBadRequestStatusCode;
extern NSInteger const kELAPIUnauthorizedStatusCode;
extern NSInteger const kELAPINotFoundStatusCode;
extern NSInteger const kELAPIServerError;

#endif /* ELConstants_h */
