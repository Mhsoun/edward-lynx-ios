//
//  ELAPIClient.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAPIClient.h"

@implementation ELAPIClient

#pragma mark - Class Methods

+ (NSString *)hostURL {
    return kELAPIRootEndpoint;
}

#pragma mark - Public Methods

- (void)performAuthenticatedTask:(BOOL)isAuthenticated
                     withRequest:(NSMutableURLRequest *)request
                      completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion {
    NSURLSessionDataTask *dataTask;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    dataTask = [manager dataTaskWithRequest:request
                          completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        AppDelegate *delegate;
        NSString *errorMessage;
        UIAlertController *alertController;
        __kindof UIViewController *visibleViewController;
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (error && httpResponse.statusCode == kELAPIUnauthorizedStatusCode) {
            // Check if task requires user to be authenticated to invoke refreshing of credentials
            if (isAuthenticated) {
                [ELUtils processReauthenticationWithCompletion:^{
                    ELOAuthInstance *oauthInstance = (ELOAuthInstance *)[ELUtils getUserDefaultsCustomObjectForKey:kELAuthInstanceUserDefaultsKey];
                    
                    [request setValue:oauthInstance.authHeader forHTTPHeaderField:@"Authorization"];
                    
                    // Re-execute task
                    [self performAuthenticatedTask:isAuthenticated
                                       withRequest:request
                                        completion:completion];
                }];
            }
            
            return;
        }
                              
        if (responseDict[@"error"]) {
            error = [NSError errorWithDomain:kELErrorDomain
                                        code:httpResponse.statusCode
                                    userInfo:responseDict];
        } else if (error) {
            delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            errorMessage = [NSString stringWithFormat:kELDefaultAlertMessage, error.localizedDescription];
            visibleViewController = [delegate visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
            alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                  message:errorMessage
                                                           preferredStyle:UIAlertControllerStyleAlert];
          
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil]];
            [visibleViewController presentViewController:alertController
                                                animated:YES
                                              completion:nil];
        }
        
        completion(response, responseDict, error);
    }];
    
    [dataTask resume];
}

- (NSMutableURLRequest *)requestFor:(NSString *)endpoint method:(NSString *)method {
    return [self requestFor:endpoint
                     method:method
                 bodyParams:nil
                queryParams:nil];
}

- (NSMutableURLRequest *)requestFor:(NSString *)endpoint
                             method:(NSString *)method
                         bodyParams:(NSDictionary *)params {
    return [self requestFor:endpoint
                     method:method
                 bodyParams:params
                queryParams:nil];
}

- (NSMutableURLRequest *)requestFor:(NSString *)endpoint
                             method:(NSString *)method
                        queryParams:(NSDictionary *)params {
    return [self requestFor:endpoint
                     method:method
                 bodyParams:nil
                queryParams:params];
}

- (NSMutableURLRequest *)requestFor:(NSString *)endpoint
                             method:(NSString *)method
                         bodyParams:(NSDictionary *)bodyParams
                        queryParams:(NSDictionary *)queryParams {
    NSMutableURLRequest *request;
    ELOAuthInstance *oauthInstance = [ELUtils getUserDefaultsCustomObjectForKey:kELAuthInstanceUserDefaultsKey];
    
    endpoint = [NSString stringWithFormat:@"%@/%@", [[self class] hostURL], endpoint];
    
    if (![method isEqualToString:kELAPIGetHTTPMethod]) {
        request = [[AFJSONRequestSerializer serializer] requestWithMethod:method
                                                                URLString:endpoint
                                                               parameters:bodyParams ? bodyParams : queryParams
                                                                    error:nil];
    } else {
        request = [[AFHTTPRequestSerializer serializer] requestWithMethod:method
                                                                URLString:endpoint
                                                               parameters:queryParams ? queryParams : bodyParams
                                                                    error:nil];
    }
    
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setHTTPMethod:method];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30.0];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                            
    if (oauthInstance) {
        [request setValue:oauthInstance.authHeader forHTTPHeaderField:@"Authorization"];
    }
    
    return request;
}

@end
