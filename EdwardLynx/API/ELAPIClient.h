//
//  ELAPIClient.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

@interface ELAPIClient : NSObject

+ (NSString *)hostURL;

- (void)performAuthenticatedTask:(BOOL)isAuthenticated
                     withRequest:(NSMutableURLRequest *)request
                      completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
- (NSMutableURLRequest *)requestFor:(NSString *)endpoint
                             method:(NSString *)method;
- (NSMutableURLRequest *)requestFor:(NSString *)endpoint
                             method:(NSString *)method
                         bodyParams:(NSDictionary *)params;
- (NSMutableURLRequest *)requestFor:(NSString *)endpoint
                             method:(NSString *)method
                        queryParams:(NSDictionary *)params;
- (NSMutableURLRequest *)requestFor:(NSString *)endpoint
                             method:(NSString *)method
                         bodyParams:(NSDictionary *)bodyParams
                        queryParams:(NSDictionary *)queryParams;

@end
