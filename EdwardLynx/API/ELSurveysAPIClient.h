//
//  ELSurveysAPIClient.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAPIClient.h"

@interface ELSurveysAPIClient : ELAPIClient

- (void)currentUserSurveysWithCompletion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
- (void)createInstantFeedbackWithParams:(NSDictionary *)params
                             completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
- (void)submitAnswerForSurveyWithId:(int64_t)surveyId
                             params:(NSDictionary *)params
                         completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
- (void)updateUserSurveyWithParams:(NSDictionary *)params
                        completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
- (void)userSurveyForId:(int64_t)surveyId
             completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
- (void)userSurveyQuestionsForId:(int64_t)surveyId
                      completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;

@end
