//
//  ELAPIClient.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "ELAPIClient.h"
#import "AppDelegate.h"
#import "ELOAuthInstance.h"

#pragma mark - Private Constants

static NSString * const kELInvalidCredentials = @"invalid_credentials";
static NSString * const kELApplicationJSON = @"application/json";

@implementation ELAPIClient

#pragma mark - Class Methods

+ (NSString *)hostURL {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:kELAPIClientPlistKey][@"URL"];
}

#pragma mark - Public Methods

- (void)getRequestAtLink:(NSString *)link
             queryParams:(NSDictionary *)queryParams
              completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSMutableURLRequest *request = [self requestFor:link
                                             method:kELAPIGetHTTPMethod
                                        queryParams:queryParams];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

- (void)performAuthenticatedTask:(BOOL)isAuthenticated
                     withRequest:(NSMutableURLRequest *)request
                      completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSURLSessionDataTask *dataTask = [AppSingleton.manager dataTaskWithRequest:request
                                                             completionHandler:^(NSURLResponse *response,
                                                                                 id responseObject,
                                                                                 NSError *error) {
        NSString *errorMessage;
        UIAlertController *alertController;
        __kindof UIViewController *visibleViewController;
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
        DLog(@"Request URL: %@", request.URL.absoluteString);
                                                                 
        if (error) {
            DLog(@"%@", error.localizedDescription);
        }
        
//        if ((error && httpResponse.statusCode == kELAPIUnauthorizedStatusCode) &&
//            (responseDict[@"error"] && ![responseDict[@"error"] isEqualToString:kELInvalidCredentials])) {
            // Check if task requires user to be authenticated to invoke refreshing of credentials
        if ((error && httpResponse.statusCode == kELAPIUnauthorizedStatusCode) && isAuthenticated) {
            [ELUtils processReauthenticationWithCompletion:^(NSURLResponse *response,
                                                             NSDictionary *responseDict,
                                                             NSError *error) {
                ELOAuthInstance *oauthInstance;
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (error) {
                    if (httpResponse.statusCode == kELAPIUnauthorizedStatusCode) {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kELAuthInstanceUserDefaultsKey];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    
                    completion(response, responseDict, error);
                    
                    return;
                }
                
                oauthInstance = (ELOAuthInstance *)[ELUtils getUserDefaultsCustomObjectForKey:kELAuthInstanceUserDefaultsKey];
                
                // Re-execute task
                [request setValue:oauthInstance.authHeader forHTTPHeaderField:@"Authorization"];
                [self performAuthenticatedTask:isAuthenticated
                                   withRequest:request
                                    completion:completion];
            }];
            
            return;
        } else if (responseDict[@"error"]) {
            error = [NSError errorWithDomain:kELErrorDomain
                                        code:httpResponse.statusCode
                                    userInfo:responseDict];
        } else if (error) {
//            if (httpResponse.statusCode == kELAPIServerError) {
//                completion(response, responseDict, error);
//                
//                return;
//            }
            
//            if (httpResponse.statusCode == kELAPIServerError) {
//                errorMessage = NSLocalizedString(@"kELServerMessage", nil);
//            } else {
//                errorMessage = Format(NSLocalizedString(@"kELDefaultAlertMessage", nil),
//                                      error.localizedDescription);
//            }
            
            errorMessage = NSLocalizedString(@"kELServerMessage", nil);
            
            // For handling overlapping UIAlertController instances
            if (visibleViewController.presentedViewController &&
                [visibleViewController.presentedViewController isKindOfClass:[UIAlertController class]]) {
                [visibleViewController dismissViewControllerAnimated:YES completion:nil];
            }
            
            visibleViewController = [ApplicationDelegate visibleViewController:Application.keyWindow.rootViewController];
            alertController = Alert(NSLocalizedString(@"kELErrorLabel", nil), errorMessage);
          
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELOkButton", nil)
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
    
    if (![endpoint containsString:[[self class] hostURL]]) {
        endpoint = Format(@"%@/%@", [[self class] hostURL], endpoint);
    }    
    
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
    
    if ([method isEqualToString:kELAPIDeleteHTTPMethod]) {
        [request setValue:kELApplicationJSON forHTTPHeaderField:@"Content-Type"];
    }
    
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setHTTPMethod:method];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30.0];
    [request setValue:kELApplicationJSON forHTTPHeaderField:@"Accept"];
                            
    if (oauthInstance) {
        [request setValue:oauthInstance.authHeader forHTTPHeaderField:@"Authorization"];
    }
    
    return request;
}

@end
