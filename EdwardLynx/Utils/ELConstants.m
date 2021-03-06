//
//  ELConstants.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 07/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELConstants.h"

#pragma mark - .plist Keys (Root)

NSString * const kELAPIClientPlistKey = @"APIClient";
NSString * const kELFabricPlistKey = @"Fabric";
NSString * const kELHockeyAppPlistKey = @"HockeyApp";

#pragma mark - .plist Keys (Dictionary Keys)

NSString * const kELAPITokenPlistKey = @"APIKey";
NSString * const kELAppIdPlistKey = @"AppId";

#pragma mark - Constants

NSString * const kELAPIDateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
NSString * const kELPrintDateFormat = @"MMM dd, yyyy";

NSString * const kELEdwardLynxContactUsURL = @"http://www.edwardlynx.com/contact/";

NSString * const kELErrorDomain = @"com.ingenuitymobile.EdwardLynx.error";

NSString * const kELFabricEmail = @"FabricEmail";
NSString * const kELFabricIdentifier = @"FabricIdentifier";
NSString * const kELFabricUsername = @"FabricUsername";

NSString * const kELLanguageCodeEnglish = @"en";
NSString * const kELLanguageCodeFinnish = @"fn";
NSString * const kELLanguageCodeSwedish = @"sv";

CGFloat const kELCustomScaleItemHeight = 35;
CGFloat const kELQuestionTypeDefaultHeight = 40;
CGFloat const kELQuestionTypeExpandedHeight = 80;

NSInteger const kELParticipantsMinimumCount = 3;

NSString * const kELUserRoleAdmin = @"admin";
NSString * const kELUserRoleAnalyst = @"analyst";
NSString * const kELUserRoleFeedbackProvider = @"feedback-provider";
NSString * const kELUserRoleParticipant = @"participant";
NSString * const kELUserRoleSuperAdmin = @"superadmin";
NSString * const kELUserRoleSupervisor = @"supervisor";

#pragma mark - Email Link Paths

NSString * const kELAPIEmailLinkFeedback = @"/instant-feedbacks/answer/";
NSString * const kELAPIEmailLinkSurveyAnswer = @"/survey/answer/";

#pragma mark - Endpoints

NSString * const kELAPIVersionNamespace = @"api/v1";

NSString * const kELAPILoginEndpoint = @"oauth/token";

NSString * const kELAPIDevelopmentPlansEndpoint = @"%@/dev-plans";
NSString * const kELAPIDevelopmentPlanEndpoint = @"%@/dev-plans/%@";

NSString * const kELAPIExchangeInstantFeedbackEndpoint = @"%@/%@/instant-feedbacks/exchange/%@";
NSString * const kELAPIExchangeSurveyAnswerEndpoint = @"%@/%@/surveys/exchange/%@";

NSString * const kELAPIInstantFeedbacksEndpoint = @"%@/instant-feedbacks";
NSString * const kELAPIInstantFeedbackEndpoint = @"%@/instant-feedbacks/%@";
NSString * const kELAPIInstantFeedbackAnswersEndpoint = @"%@/instant-feedbacks/%@/answers";
NSString * const kELAPIInstantFeedbackAddMoreParticipantsEndpoint = @"%@/instant-feedbacks/%@/recipients";
NSString * const kELAPIInstantFeedbackSharesEndpoint = @"%@/instant-feedbacks/%@/shares";

NSString * const kELAPIQuestionCategoriesEndpoint = @"%@/categories";
NSString * const kELAPIQuestionCategoryEndpoint = @"%@/categories/%@";
NSString * const kELAPIQuestionsEndpoint = @"%@/questions";
NSString * const kELAPIQuestionEndpoint = @"%@/questions/%@";

NSString * const kELAPISurveysEndpoint = @"%@/surveys";
NSString * const kELAPISurveyEndpoint = @"%@/surveys/%@";
NSString * const kELAPISurveyAnswersEndpoint = @"%@/surveys/%@/answers";
NSString * const kELAPISurveyQuestionsEndpoint = @"%@/surveys/%@/questions";
NSString * const kELAPISurveyRecipientsEndpoint = @"%@/surveys/%@/recipients";
NSString * const kELAPISurveyResultsEndpoint = @"%@/surveys/%@/results";

NSString * const kELAPITeamDevelopmentPlanEndpoint = @"%@/dev-plans-manager/teams/%@";
NSString * const kELAPITeamDevelopmentPlansEndpoint = @"%@/dev-plans-manager/teams";
NSString * const kELAPITeamReportsEndpoint = @"%@/dev-plans-manager/reports";
NSString * const kELAPITeamUsersEndpoint = @"%@/dev-plans-manager/users";

NSString * const kELAPIUserEndpoint = @"%@/user";
NSString * const kELAPIUserDashboardEndpoint = @"%@/user/dashboard";
NSString * const kELAPIUserDeviceEndpoint = @"%@/user/devices";
NSString * const kELAPIUserForgotPasswordEndpoint = @"%@/user/forgotpassword";
NSString * const kELAPIUsersEndpoint = @"%@/users?type=list";

#pragma mark - HTTP Methods

NSString * const kELAPIDeleteHTTPMethod = @"DELETE";
NSString * const kELAPIGetHTTPMethod = @"GET";
NSString * const kELAPIPatchHTTPMethod = @"PATCH";
NSString * const kELAPIPostHTTPMethod = @"POST";
NSString * const kELAPIPutHTTPMethod = @"PUT";

#pragma mark - NSNotificationCenter Names

NSString * const kELGoalActionAddNotification = @"GoalActionAddNotification";
NSString * const kELGoalActionOptionsNotification = @"GoalActionOptionsNotification";
NSString * const kELInstantFeedbackTabNotification = @"InstantFeedbackTabNotification";
NSString * const kELManagerReportDetailsNotification = @"ManagerReportDetailsNotification";
NSString * const kELManagerReportEmailNotification = @"ManagerReportEmailNotification";
NSString * const kELPopupCloseNotification = @"PopupClosehNotification";
NSString * const kELTabPageSearchNotification = @"TabPageSearchNotification";
NSString * const kELTeamChartSelectionNotification = @"TeamChartSelectionNotification";
NSString * const kELTeamSeeMoreNotification = @"TeamSeeMoreNotification";

#pragma mark - NSUserDefaults Keys

NSString * const kELAuthInstanceUserDefaultsKey = @"AuthInstanceUserDefaults";
NSString * const kELAuthCredentialsUserDefaultsKey = @"AuthCredentialsUserDefaultsKey";
NSString * const kELDeviceTokenUserDefaultsKey = @"DeviceTokenUserDefaultsKey";

#pragma mark - RNThemeManager .plist Keys

NSString * const kELDevPlanColor = @"devPlanColor";
NSString * const kELFeedbackColor = @"feedbackColor";
NSString * const kELLynxColor = @"lynxColor";
NSString * const kELOtherColor = @"otherColor";
NSString * const kELTeamColor = @"teamColor";

NSString * const kELContainerColor = @"containerColor";
NSString * const kELDevPlanSeparatorColor = @"devPlanSeparatorColor";
NSString * const kELHeaderColor = @"headerColor";
NSString * const kELInactiveColor = @"inactiveColor";
NSString * const kELSubtextColor = @"subtextColor";
NSString * const kELSurveySeparatorColor = @"surveySeparatorColor";
NSString * const kELTextFieldBGColor = @"textFieldBGColor";
NSString * const kELTextFieldInputColor = @"textFieldInputColor";

NSString * const kELBlackColor = @"blackColor";
NSString * const kELBlueColor = @"blueColor";
NSString * const kELDarkGrayColor = @"darkGrayColor";
NSString * const kELDarkVioletColor = @"darkVioletColor";
NSString * const kELGrayColor = @"grayColor";
NSString * const kELGreenColor = @"greenColor";
NSString * const kELLightGrayColor = @"lightGrayColor";
NSString * const kELLightVioletColor = @"lightVioletColor";
NSString * const kELPinkColor = @"pinkColor";
NSString * const kELOrangeColor = @"orangeColor";
NSString * const kELRedColor = @"redColor";
NSString * const kELVioletColor = @"violetColor";
NSString * const kELWhiteColor = @"whiteColor";

#pragma mark - Status Codes

NSInteger const kELAPIOKStatusCode = 200;
NSInteger const kELAPICreatedStatusCode = 201;
NSInteger const kELAPINoContentStatusCode = 204;
NSInteger const kELAPIBadRequestStatusCode = 400;
NSInteger const kELAPIUnauthorizedStatusCode = 401;
NSInteger const kELAPINotFoundStatusCode = 404;
NSInteger const kELAPIServerError = 500;
