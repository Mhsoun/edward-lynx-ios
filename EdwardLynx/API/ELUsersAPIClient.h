//
//  ELUsersAPIClient.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAPIClient.h"

@interface ELUsersAPIClient : ELAPIClient

- (void)dashboardDataWithCompletion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
- (void)reauthenticateWithCompletion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
- (void)recoverPasswordThruEmail:(NSString *)email
                      completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
- (void)registerFirebaseToken:(NSString *)token
                     deviceId:(NSString *)deviceId
               withCompletion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
- (void)retrieveUsersWithCompletion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
- (void)updateUserInfoWithParams:(NSDictionary *)params
                      completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
- (void)userInfoWithCompletion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;

@end
