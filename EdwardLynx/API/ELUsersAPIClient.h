//
//  ELUsersAPIClient.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAPIClient.h"

@interface ELUsersAPIClient : ELAPIClient

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                      completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
- (void)updateUserInfoWithParams:(NSDictionary *)params
                      completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
- (void)userInfoWithCompletion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;

@end
