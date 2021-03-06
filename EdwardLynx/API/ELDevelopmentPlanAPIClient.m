//
//  ELDevelopmentPlanAPIClient.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDevelopmentPlanAPIClient.h"

@implementation ELDevelopmentPlanAPIClient

#pragma mark - Development Plan Goal

- (void)currentUserDevelopmentPlansWithCompletion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPIDevelopmentPlansEndpoint, kELAPIVersionNamespace);
    NSMutableURLRequest *request = [self requestFor:endpoint method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)createDevelopmentPlansWithParams:(NSDictionary *)params
                              completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPIDevelopmentPlansEndpoint, kELAPIVersionNamespace);
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPostHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)developmentPlanWithId:(int64_t)devPlanId
               withCompletion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPIDevelopmentPlanEndpoint,
                                kELAPIVersionNamespace,
                                @(devPlanId));
    NSMutableURLRequest *request = [self requestFor:endpoint method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)developmentPlansWithParams:(NSDictionary *)params
                        completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPIDevelopmentPlansEndpoint, kELAPIVersionNamespace);
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIGetHTTPMethod
                                        queryParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)updateDevelopmentPlanWithId:(int64_t)devPlanId
                             params:(NSDictionary *)params
                         completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPIDevelopmentPlanEndpoint,
                                kELAPIVersionNamespace,
                                @(devPlanId));
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPatchHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

#pragma mark - Development Plan Goals

- (void)addDevelopmentPlanGoalWithParams:(NSDictionary *)params
                                    link:(NSString *)link
                              completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSMutableURLRequest *request = [self requestFor:link
                                             method:kELAPIPostHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)deleteDevelopmentPlanGoalWithLink:(NSString *)link
                               completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSMutableURLRequest *request = [self requestFor:link method:kELAPIDeleteHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)updateDevelopmentPlanGoalWithParams:(NSDictionary *)params
                                       link:(NSString *)link
                                 completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSMutableURLRequest *request = [self requestFor:link
                                             method:kELAPIPatchHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

#pragma mark - Development Plan Goal Actions

- (void)addDevelopmentPlanGoalActionWithParams:(NSDictionary *)params
                                          link:(NSString *)link
                                    completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSMutableURLRequest *request = [self requestFor:link
                                             method:kELAPIPostHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)deleteDevelopmentPlanGoalActionWithLink:(NSString *)link
                                     completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSMutableURLRequest *request = [self requestFor:link method:kELAPIDeleteHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)updateDevelopmentPlanGoalActionWithParams:(NSDictionary *)params
                                             link:(NSString *)link
                                       completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSMutableURLRequest *request = [self requestFor:link
                                             method:kELAPIPatchHTTPMethod
                                         bodyParams:params];
        
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

@end
