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

- (void)addInstantFeedbackParticipantsWithId:(int64_t)instantFeedbackId
                                      params:(NSDictionary *)params
                                  completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPIInstantFeedbackAddMoreParticipantsEndpoint,
                                kELAPIVersionNamespace,
                                @(instantFeedbackId));
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPostHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)answerInstantFeedbackWithId:(int64_t)instantFeedbackId
                             params:(NSDictionary *)params completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPIInstantFeedbackAnswersEndpoint,
                                kELAPIVersionNamespace,
                                @(instantFeedbackId));
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPostHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)createInstantFeedbackWithParams:(NSDictionary *)params
                             completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPIInstantFeedbacksEndpoint, kELAPIVersionNamespace);
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPostHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)currentUserInstantFeedbacksWithFilter:(NSString *)filter
                                   completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPIInstantFeedbacksEndpoint, kELAPIVersionNamespace);
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIGetHTTPMethod
                                        queryParams:@{@"filter": filter}];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)instantFeedbackReportDetailsWithId:(int64_t)instantFeedbackId
                                completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPIInstantFeedbackAnswersEndpoint,
                                kELAPIVersionNamespace,
                                @(instantFeedbackId));
    NSMutableURLRequest *request = [self requestFor:endpoint method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)instantFeedbackWithId:(int64_t)instantFeedbackId completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPIInstantFeedbackEndpoint,
                                kELAPIVersionNamespace,
                                @(instantFeedbackId));
    NSMutableURLRequest *request = [self requestFor:endpoint method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)shareInstantFeedbackWithId:(int64_t)instantFeedbackId
                            params:(NSDictionary *)params
                        completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPIInstantFeedbackSharesEndpoint,
                                kELAPIVersionNamespace,
                                @(instantFeedbackId));
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPostHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

#pragma mark - Surveys

- (void)currentUserSurveysWithQueryParams:(NSDictionary *)params
                               completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPISurveysEndpoint, kELAPIVersionNamespace);
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIGetHTTPMethod
                                        queryParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)inviteOthersToRateYouWithId:(int64_t)surveyId
                             params:(NSDictionary *)params
                         completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPISurveyRecipientsEndpoint,
                                kELAPIVersionNamespace,
                                @(surveyId));
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPostHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)submitAnswerForSurveyWithId:(int64_t)surveyId
                             params:(NSDictionary *)params
                         completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPISurveyAnswersEndpoint,
                                kELAPIVersionNamespace,
                                @(surveyId));
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPostHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)surveyReportDetailsWithId:(int64_t)surveyId
                       completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPISurveyResultsEndpoint,
                                kELAPIVersionNamespace,
                                @(surveyId));
    NSMutableURLRequest *request = [self requestFor:endpoint method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)updateUserSurveyWithParams:(NSDictionary *)params
                        completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPISurveysEndpoint, kELAPIVersionNamespace);
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPatchHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)userSurveyWithId:(int64_t)surveyId
                  params:(NSDictionary *)params
              completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPISurveyEndpoint,
                                kELAPIVersionNamespace,
                                @(surveyId));
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIGetHTTPMethod
                                        queryParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)userSurveyQuestionsWithId:(int64_t)surveyId
                           params:(NSDictionary *)params
                       completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPISurveyQuestionsEndpoint,
                                kELAPIVersionNamespace,
                                @(surveyId));
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIGetHTTPMethod
                                        queryParams:params];
        
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

@end
