//
//  ELSurveysAPIClient.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveysAPIClient.h"

@implementation ELSurveysAPIClient

- (void)createUserSurveyWithParams:(NSDictionary *)params
                        completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSMutableURLRequest *request = [super requestFor:kELAPISurveysEndpoint
                                              method:kELAPIPostHTTPMethod
                                          bodyParams:params];
    
    [super performAuthenticatedTask:YES
                        withRequest:request
                         completion:completion];
}

- (void)currentUserSurveysWithCompletion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSMutableURLRequest *request = [super requestFor:kELAPISurveysEndpoint
                                              method:kELAPIGetHTTPMethod];
    
    [super performAuthenticatedTask:YES
                        withRequest:request
                         completion:completion];
}

- (void)updateUserSurveyWithParams:(NSDictionary *)params
                        completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSMutableURLRequest *request = [super requestFor:kELAPISurveysEndpoint
                                              method:kELAPIPatchHTTPMethod
                                          bodyParams:params];
    
    [super performAuthenticatedTask:YES
                        withRequest:request
                         completion:completion];
}

- (void)userSurveyForId:(int64_t)surveyId
             completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSMutableURLRequest *request = [super requestFor:[NSString stringWithFormat:kELAPISurveyDetailsEndpoint, @(surveyId)]
                                              method:kELAPIGetHTTPMethod];
    
    [super performAuthenticatedTask:YES
                        withRequest:request
                         completion:completion];
}

@end
