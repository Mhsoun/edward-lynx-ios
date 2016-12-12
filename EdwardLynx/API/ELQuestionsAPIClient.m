//
//  ELQuestionsAPIClient.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestionsAPIClient.h"

@implementation ELQuestionsAPIClient

- (void)createQuestionWithParams:(NSDictionary *)params
                      completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSMutableURLRequest *request = [super requestFor:kELAPIQuestionsEndpoint
                                              method:kELAPIPostHTTPMethod
                                          bodyParams:params];
    
    [super performAuthenticatedTask:YES
                        withRequest:request
                         completion:completion];
}

- (void)updateQuestionForId:(int64_t)questionId
                     params:(NSDictionary *)params
                 completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSMutableURLRequest *request = [super requestFor:[NSString stringWithFormat:kELAPIQuestionDetailsEndpoint, @(questionId)]
                                              method:kELAPIPutHTTPMethod
                                          bodyParams:params];
    
    [super performAuthenticatedTask:YES
                        withRequest:request
                         completion:completion];
}

@end
