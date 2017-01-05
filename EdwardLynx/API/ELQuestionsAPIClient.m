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
    NSMutableURLRequest *request = [self requestFor:kELAPIQuestionsEndpoint
                                             method:kELAPIPostHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)updateQuestionForId:(int64_t)questionId
                     params:(NSDictionary *)params
                 completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSMutableURLRequest *request = [self requestFor:[NSString stringWithFormat:kELAPIQuestionEndpoint, @(questionId)]
                                             method:kELAPIPutHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

@end

@implementation ELQuestionCategoriesAPIClient

- (void)categoriesOfUserWithCompletion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSMutableURLRequest *request = [self requestFor:kELAPIQuestionCategoriesEndpoint method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)createQuestionCategoryWithParams:(NSDictionary *)params
                              completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSMutableURLRequest *request = [self requestFor:kELAPIQuestionCategoriesEndpoint method:kELAPIPostHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)updateQuestionCategoryForId:(int64_t)categoryId
                             params:(NSDictionary *)params
                         completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSMutableURLRequest *request = [self requestFor:[NSString stringWithFormat:kELAPIQuestionCategoryEndpoint, categoryId]
                                             method:kELAPIPutHTTPMethod];
    
    [self performAuthenticatedTask:YES
                        withRequest:request
                         completion:completion];
}

@end
