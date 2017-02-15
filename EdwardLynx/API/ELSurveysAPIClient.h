//
//  ELSurveysAPIClient.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAPIClient.h"

@interface ELSurveysAPIClient : ELAPIClient

- (void)addInstantFeedbackParticipantsWithId:(int64_t)instantFeedbackId
                                      params:(NSDictionary *)params
                                  completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)answerInstantFeedbackWithId:(int64_t)instantFeedbackId
                             params:(NSDictionary *)params
                         completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)createInstantFeedbackWithParams:(NSDictionary *)params
                             completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)currentUserInstantFeedbacksWithFilter:(NSString *)filter
                                   completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)instantFeedbackReportDetailsWithId:(int64_t)instantFeedbackId
                                completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)instantFeedbackWithId:(int64_t)instantFeedbackId
                   completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)shareInstantFeedbackWithId:(int64_t)instantFeedbackId
                            params:(NSDictionary *)params
                        completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;

- (void)currentUserSurveysWithQueryParams:(NSDictionary *)params
                               completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)submitAnswerForSurveyWithId:(int64_t)surveyId
                             params:(NSDictionary *)params
                         completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)updateUserSurveyWithParams:(NSDictionary *)params
                        completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)userSurveyWithId:(int64_t)surveyId
              completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)userSurveyQuestionsWithId:(int64_t)surveyId
                       completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;

@end
