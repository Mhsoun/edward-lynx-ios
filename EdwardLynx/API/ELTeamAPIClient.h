//
//  ELTeamAPIClient.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 22/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAPIClient.h"

@interface ELTeamAPIClient : ELAPIClient

- (void)enableUsersWithParams:(NSDictionary *)params
                   completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)linkedUsersDevPlansWithParams:(NSDictionary *)params
                           completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;

- (void)createTeamDevPlanWithParams:(NSDictionary *)params
                         completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)deleteTeamDevPlanDetailsWithId:(int64_t)teamDevPlanId
                            completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)teamDevPlanDetailsWithId:(int64_t)teamDevPlanId
                      completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)teamDevPlansWithCompletion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)updateTeamDevPlanDetailsWithId:(int64_t)teamDevPlanId
                                params:(NSDictionary *)params
                            completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;

@end
