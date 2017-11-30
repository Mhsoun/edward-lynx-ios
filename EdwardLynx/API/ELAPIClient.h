//
//  ELAPIClient.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

@interface ELAPIClient : NSObject


/**
 @return API's host URL
 */
+ (NSString *)hostURL;

/**
 Performs a GET request with the provided link.

 @param link URL of the endpoint.
 @param queryParams Contains additional parameters to be added to the link as a querystring.
 @param completion Block where the completion of request is handled.
 */
- (void)getRequestAtLink:(NSString *)link
             queryParams:(NSDictionary *)queryParams
              completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
/**
 Performs all NSMutableRequest instances and handles its completion.

 @param isAuthenticated Determines whether the request needs to be reauthenticated.
 @param request NSMutableRequest instance in which a data task to be performed.
 @param completion Block where the completion of request is handled.
 */
- (void)performAuthenticatedTask:(BOOL)isAuthenticated
                     withRequest:(NSMutableURLRequest *)request
                      completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
/**
 Generates a NSMutableRequest provided with the necessary properties
 
 @param endpoint API endpoint where the request will be called.
 @param method HTTP method type of the desired request.
 @return NSMutableRequest instance.
 */
- (NSMutableURLRequest *)requestFor:(NSString *)endpoint
                             method:(NSString *)method;
/**
 Generates a NSMutableRequest provided with the necessary properties
 
 @param endpoint API endpoint where the request will be called.
 @param method HTTP method type of the desired request.
 @param bodyParams Body to be added to the request. Used for POST/PUT reqeusts
 @return NSMutableRequest instance.
 */
- (NSMutableURLRequest *)requestFor:(NSString *)endpoint
                             method:(NSString *)method
                         bodyParams:(NSDictionary *)params;
/**
 Generates a NSMutableRequest provided with the necessary properties
 
 @param endpoint API endpoint where the request will be called.
 @param method HTTP method type of the desired request.
 @param queryParams NSDictionary wherein it is constructed to a querystring based on its key-value pairs. Used for GET/DELETE
 @return NSMutableRequest instance.
 */
- (NSMutableURLRequest *)requestFor:(NSString *)endpoint
                             method:(NSString *)method
                        queryParams:(NSDictionary *)params;
/**
 Generates a NSMutableRequest provided with the necessary properties

 @param endpoint API endpoint where the request will be called.
 @param method HTTP method type of the desired request.
 @param bodyParams Body to be added to the request. Used for POST/PUT reqeusts
 @param queryParams NSDictionary wherein it is constructed to a querystring based on its key-value pairs. Used for GET/DELETE
 @return NSMutableRequest instance.
 */
- (NSMutableURLRequest *)requestFor:(NSString *)endpoint
                             method:(NSString *)method
                         bodyParams:(NSDictionary *)bodyParams
                        queryParams:(NSDictionary *)queryParams;

@end
