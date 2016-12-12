//
//  ELConstants.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 07/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELConstants.h"

#pragma mark - .plist Keys

NSString * const kELAPITokenPlistKey = @"APIKey";
NSString * const kELHockeyAppPlistKey = @"HockeyApp";

#pragma mark - Constants

NSString * const kELErrorDomain = @"com.ingenuitymobile.EdwardLynx.error";
NSString * const kELFabricEmail = @"FabricEmail";
NSString * const kELFabricIdentifier = @"FabricIdentifier";
NSString * const kELFabricUsername = @"FabricUsername";

#pragma mark - Endpoints

NSString * const kELAPIRootEndpoint = @"[API_URL]/api/v1";
NSString * const kELAPIQuestionCategoriesEndpoint = @"/question_categories";
NSString * const kELAPIQuestionsEndpoint = @"/questions";
NSString * const kELAPISurveysEndpoint = @"surveys";
NSString * const kELAPIUserEndpoint = @"/user";
NSString * const kELAPILoginEndpoint = @"/user/login";

#pragma mark - HTTP Methods

NSString * const kELAPIDeleteHTTPMethod = @"DELETE";
NSString * const kELAPIGetHTTPMethod = @"GET";
NSString * const kELAPIPatchHTTPMethod = @"PATCH";
NSString * const kELAPIPostHTTPMethod = @"POST";
NSString * const kELAPIPutHTTPMethod = @"PUT";

#pragma mark - NSUserDefaults Keys

NSString * const kELAuthHeaderUserDefaultsKey = @"AuthHeaderUserDefaults";

#pragma mark - Status Codes

NSInteger const kELAPIOKStatusCode = 200;
NSInteger const kELAPICreatedStatusCode = 201;
NSInteger const kELAPINoContentStatusCode = 204;
NSInteger const kELAPIBadRequestStatusCode = 400;
NSInteger const kELAPIUnauthorizedStatusCode = 401;
NSInteger const kELAPINotFoundStatusCode = 404;
