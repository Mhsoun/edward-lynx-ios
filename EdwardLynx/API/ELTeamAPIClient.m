//
//  ELTeamAPIClient.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 22/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELTeamAPIClient.h"

@implementation ELTeamAPIClient

- (void)enableUsersWithParams:(NSDictionary *)params
                   completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPITeamUsersEndpoint, kELAPIVersionNamespace);
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPutHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)linkedUsersDevPlansWithParams:(NSDictionary *)params
                           completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSMutableURLRequest *request;
    NSString *endpoint = Format(kELAPITeamUsersEndpoint, kELAPIVersionNamespace);
    
    if (params) {
        request = [self requestFor:endpoint
                            method:kELAPIGetHTTPMethod
                       queryParams:params];
    } else {
        request = [self requestFor:endpoint method:kELAPIGetHTTPMethod];
    }
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)teamDevPlansWithCompletion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPITeamDevelopmentPlansEndpoint, kELAPIVersionNamespace);
    NSMutableURLRequest *request = [self requestFor:endpoint method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

@end
