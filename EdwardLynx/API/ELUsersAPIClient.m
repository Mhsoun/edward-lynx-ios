//
//  ELUsersAPIClient.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELUsersAPIClient.h"
#import "ELOAuthInstance.h"

@implementation ELUsersAPIClient

#pragma mark - Private Methods

- (void)authenticateWithBodyParams:(NSDictionary *)bodyParams
                        completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSMutableURLRequest *request;
    NSMutableDictionary *mBodyParamsDict;
    NSString *clientId = [[NSBundle mainBundle] objectForInfoDictionaryKey:kELAPIClientPlistKey][@"ID"];
    NSString *clientSecret = [[NSBundle mainBundle] objectForInfoDictionaryKey:kELAPIClientPlistKey][@"Secret"];
    
    mBodyParamsDict = [NSMutableDictionary dictionaryWithDictionary:bodyParams];
    
    [mBodyParamsDict setObject:@"*" forKey:@"scope"];
    [mBodyParamsDict setObject:clientId forKey:@"client_id"];
    [mBodyParamsDict setObject:clientSecret forKey:@"client_secret"];
    
    request = [self requestFor:kELAPILoginEndpoint
                        method:kELAPIPostHTTPMethod
                    bodyParams:mBodyParamsDict];
    
    [self performAuthenticatedTask:NO
                       withRequest:request
                        completion:completion];
}

#pragma mark - Public Methods

- (void)dashboardDataWithCompletion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPIUserDashboardEndpoint, kELAPIVersionNamespace];
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSMutableDictionary *mBodyParams = [NSMutableDictionary dictionaryWithDictionary:@{@"grant_type": @"password",
                                                                                       @"username": username,
                                                                                       @"password": password}];
    
    [self authenticateWithBodyParams:[mBodyParams copy] completion:completion];
}

- (void)reauthenticateWithCompletion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSDictionary *credsDict = [ELUtils getUserDefaultsObjectForKey:kELAuthCredentialsUserDefaultsKey];
    NSMutableDictionary *mBodyParams = [NSMutableDictionary dictionaryWithDictionary:@{@"grant_type": @"password",
                                                                                       @"username": credsDict[@"username"],
                                                                                       @"password": credsDict[@"password"]}];
    
    [self authenticateWithBodyParams:[mBodyParams copy] completion:completion];
}

- (void)registerFirebaseToken:(NSString *)token
                     deviceId:(NSString *)deviceId
               withCompletion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPIUserDeviceEndpoint, kELAPIVersionNamespace];
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPostHTTPMethod
                                         bodyParams:@{@"token": token,
                                                      @"deviceId": deviceId}];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)retrieveUsersWithCompletion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPIUsersEndpoint, kELAPIVersionNamespace];
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)updateUserInfoWithParams:(NSDictionary *)params
                      completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPIUserEndpoint, kELAPIVersionNamespace];
    NSMutableURLRequest *request = [self requestFor:endpoint
                                             method:kELAPIPatchHTTPMethod
                                         bodyParams:params];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)userInfoWithCompletion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPIUserEndpoint, kELAPIVersionNamespace];
    NSMutableURLRequest *request = [self requestFor:endpoint method:kELAPIGetHTTPMethod];
        
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

@end
