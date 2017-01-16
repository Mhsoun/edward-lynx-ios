//
//  ELSurveysAPIClient.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveysAPIClient.h"

@implementation ELSurveysAPIClient

- (void)currentUserSurveysWithCompletion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPISurveysEndpoint, kELAPIVersionNamespace];
    NSMutableURLRequest *request = [self requestFor:endpoint method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)createInstantFeedbackWithParams:(NSDictionary *)params
                             completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPIInstantFeedbackEndpoint, kELAPIVersionNamespace];
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

- (void)userSurveyForId:(int64_t)surveyId
             completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPISurveyEndpoint, kELAPIVersionNamespace, @(surveyId)];
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)userSurveyQuestionsForId:(int64_t)surveyId
                      completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPISurveyQuestionsEndpoint, kELAPIVersionNamespace, @(surveyId)];
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

@end
