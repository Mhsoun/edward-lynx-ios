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

#pragma mark - Alert Messages

NSString * const kELDefaultAlertMessage = @"%@. Please try again later.";
NSString * const kELLogoutAlertMessage = @"Logging out will require the app for your credentials next time.";

#pragma mark - Constants

NSString * const kELErrorDomain = @"com.ingenuitymobile.EdwardLynx.error";

NSString * const kELFabricEmail = @"FabricEmail";
NSString * const kELFabricIdentifier = @"FabricIdentifier";
NSString * const kELFabricUsername = @"FabricUsername";

NSString * const kELLanguageCodeEnglish = @"en";
NSString * const kELLanguageCodeFinnish = @"fn";
NSString * const kELLanguageCodeSwedish = @"sv";

NSString * const kELQuestionTypeOneToFiveScale = @"Numeric 1-5 Scale";
NSString * const kELQuestionTypeOneToTenScale = @"Numeric 1-10 Scale";
NSString * const kELQuestionTypeAgreeementScale = @"Agreement Scale";
NSString * const kELQuestionTypeYesNoScale = @"Yes/No Scale";
NSString * const kELQuestionTypeStrongAgreeementScale = @"Strong Agreement Scale";
NSString * const kELQuestionTypeText = @"Text";
NSString * const kELQuestionTypeInvertedAgreementScale = @"Inverted Agreement Scale";
NSString * const kELQuestionTypeOneToTenWithExplanation = @"1-10 with explanation";
NSString * const kELQuestionTypeCustomScale = @"Custom Scale";

NSString * const kELUserRoleAdmin = @"admin";
NSString * const kELUserRoleAnalyst = @"analyst";
NSString * const kELUserRoleFeedbackProvider = @"feedback-provider";
NSString * const kELUserRoleParticipant = @"participant";
NSString * const kELUserRoleSuperAdmin = @"superadmin";
NSString * const kELUserRoleSupervisor = @"supervisor";

#pragma mark - Endpoints

NSString * const kELAPIRootEndpoint = @"http://edwardlynx.ingenuity.ph";
NSString * const kELAPIVersionNamespace = @"api/v1";
NSString * const kELAPIQuestionCategoriesEndpoint = @"%@/question_categories";
NSString * const kELAPIQuestionCategoryEndpoint = @"%@/question_categories/%@";
NSString * const kELAPIQuestionsEndpoint = @"%@/questions";
NSString * const kELAPIQuestionEndpoint = @"%@/questions/%@";
NSString * const kELAPISurveysEndpoint = @"%@/surveys";
NSString * const kELAPISurveyEndpoint = @"%@/surveys/%@";
NSString * const kELAPIUserEndpoint = @"%@/user";
NSString * const kELAPILoginEndpoint = @"oauth/token";

#pragma mark - HTTP Methods

NSString * const kELAPIDeleteHTTPMethod = @"DELETE";
NSString * const kELAPIGetHTTPMethod = @"GET";
NSString * const kELAPIPatchHTTPMethod = @"PATCH";
NSString * const kELAPIPostHTTPMethod = @"POST";
NSString * const kELAPIPutHTTPMethod = @"PUT";

#pragma mark - NSUserDefaults Keys

NSString * const kELAuthInstanceUserDefaultsKey = @"AuthInstanceUserDefaults";
NSString * const kELAuthCredentialsUserDefaultsKey = @"AuthCredentialsUserDefaultsKey";

#pragma mark - RNThemeManager .plist Keys

NSString * const kELBlackColor = @"blackColor";
NSString * const kELWhiteColor = @"whiteColor";
NSString * const kELGreenColor = @"greenColor";
NSString * const kELLightGrayColor = @"lightGrayColor";
NSString * const kELGrayColor = @"grayColor";
NSString * const kELDarkGrayColor = @"darkGrayColor";
NSString * const kELLightVioletColor = @"lightVioletColor";
NSString * const kELVioletColor = @"violetColor";
NSString * const kELDarkVioletColor = @"darkVioletColor";

#pragma mark - Status Codes

NSInteger const kELAPIOKStatusCode = 200;
NSInteger const kELAPICreatedStatusCode = 201;
NSInteger const kELAPINoContentStatusCode = 204;
NSInteger const kELAPIBadRequestStatusCode = 400;
NSInteger const kELAPIUnauthorizedStatusCode = 401;
NSInteger const kELAPINotFoundStatusCode = 404;
