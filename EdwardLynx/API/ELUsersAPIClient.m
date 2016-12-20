//
//  ELUsersAPIClient.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELUsersAPIClient.h"

@implementation ELUsersAPIClient

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                      completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSMutableURLRequest *request;
    NSMutableDictionary *mBodyParamsDict;
    NSString *clientId = [[NSBundle mainBundle] objectForInfoDictionaryKey:kELAPIClientPlistKey][@"ID"];
    NSString *clientSecret = [[NSBundle mainBundle] objectForInfoDictionaryKey:kELAPIClientPlistKey][@"Secret"];
    
    mBodyParamsDict = [NSMutableDictionary dictionaryWithDictionary:@{@"username": username,
                                                                      @"password": password}];
    
    [mBodyParamsDict setObject:@"*" forKey:@"scope"];
    [mBodyParamsDict setObject:@"password" forKey:@"grant_type"];
    [mBodyParamsDict setObject:clientId forKey:@"client_id"];
    [mBodyParamsDict setObject:clientSecret forKey:@"client_secret"];
    
    request = [super requestFor:kELAPILoginEndpoint
                         method:kELAPIPostHTTPMethod
                     bodyParams:mBodyParamsDict];
    
    [super performAuthenticatedTask:NO
                        withRequest:request
                         completion:completion];
}

- (void)updateUserInfoWithParams:(NSDictionary *)params
                      completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSMutableURLRequest *request = [super requestFor:kELAPIUserEndpoint
                                              method:kELAPIPutHTTPMethod
                                          bodyParams:params];
    
    [super performAuthenticatedTask:YES
                        withRequest:request
                         completion:completion];
}

- (void)userInfoWithCompletion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSMutableURLRequest *request = [super requestFor:kELAPIUserEndpoint
                                              method:kELAPIGetHTTPMethod
                                          bodyParams:nil];
    
    [super performAuthenticatedTask:YES
                        withRequest:request
                         completion:completion];
}

@end
