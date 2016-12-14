//
//  ELConstants.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 07/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#ifndef ELConstants_h
#define ELConstants_h

#pragma mark - .plist Keys

extern NSString * const kELAPITokenPlistKey;
extern NSString * const kELHockeyAppPlistKey;

#pragma mark - Constants

extern NSString * const kELErrorDomain;
extern NSString * const kELFabricEmail;
extern NSString * const kELFabricIdentifier;
extern NSString * const kELFabricUsername;

#pragma mark - Endpoints

extern NSString * const kELAPIRootEndpoint;
extern NSString * const kELAPIQuestionCategoriesEndpoint;
extern NSString * const kELAPIQuestionCategoryEndpoint;
extern NSString * const kELAPIQuestionsEndpoint;
extern NSString * const kELAPIQuestionEndpoint;
extern NSString * const kELAPISurveysEndpoint;
extern NSString * const kELAPISurveyEndpoint;
extern NSString * const kELAPIUserEndpoint;
extern NSString * const kELAPILoginEndpoint;

#pragma mark - HTTP Methods

extern NSString * const kELAPIDeleteHTTPMethod;
extern NSString * const kELAPIGetHTTPMethod;
extern NSString * const kELAPIPatchHTTPMethod;
extern NSString * const kELAPIPostHTTPMethod;
extern NSString * const kELAPIPutHTTPMethod;

#pragma mark - NSUserDefaults Keys

extern NSString * const kELAuthHeaderUserDefaultsKey;

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
