//
//  ELSurveysAPIClient.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveysAPIClient.h"

@implementation ELSurveysAPIClient

#pragma mark - Instant Feedback

- (void)answerInstantFeedbackWithId:(int64_t)instantFeedbackId
                             params:(NSDictionary *)params completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPIInstantFeedbackAnswersEndpoint, kELAPIVersionNamespace, @(instantFeedbackId)];
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPostHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)createInstantFeedbackWithParams:(NSDictionary *)params
                             completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPIInstantFeedbacksEndpoint, kELAPIVersionNamespace];
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPostHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)currentUserInstantFeedbacksWithFilter:(NSString *)filter
                                   completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPIInstantFeedbacksEndpoint, kELAPIVersionNamespace];
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIGetHTTPMethod
                                        queryParams:@{@"filter": filter}];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)instantFeedbackReportDetailsWithId:(int64_t)instantFeedbackId
                                completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPIInstantFeedbackAnswersEndpoint, kELAPIVersionNamespace, @(instantFeedbackId)];
    NSMutableURLRequest *request = [self requestFor:endpoint method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)instantFeedbackWithId:(int64_t)instantFeedbackId completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPIInstantFeedbackEndpoint, kELAPIVersionNamespace, @(instantFeedbackId)];
    NSMutableURLRequest *request = [self requestFor:endpoint method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)shareInstantFeedback:(int64_t)instantFeedbackId
                      params:(NSDictionary *)params
                  completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPIInstantFeedbackSharesEndpoint, kELAPIVersionNamespace, @(instantFeedbackId)];
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPostHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

#pragma mark - Surveys

- (void)currentUserSurveysWithCompletion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPISurveysEndpoint, kELAPIVersionNamespace];
    NSMutableURLRequest *request = [self requestFor:endpoint method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)submitAnswerForSurveyWithId:(int64_t)surveyId
                             params:(NSDictionary *)params
                         completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPISurveyAnswersEndpoint, kELAPIVersionNamespace, @(surveyId)];
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPostHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)updateUserSurveyWithParams:(NSDictionary *)params
                        completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPISurveysEndpoint, kELAPIVersionNamespace];
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPatchHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)userSurveyWithId:(int64_t)surveyId
              completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPISurveyEndpoint, kELAPIVersionNamespace, @(surveyId)];
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)userSurveyQuestionsWithId:(int64_t)surveyId
                       completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPISurveyQuestionsEndpoint, kELAPIVersionNamespace, @(surveyId)];
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

@end
