//
//  ELDevelopmentPlanAPIClient.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAPIClient.h"

@interface ELDevelopmentPlanAPIClient : ELAPIClient

- (void)currentUserDevelopmentPlansWithCompletion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)createDevelopmentPlansWithParams:(NSDictionary *)params
                              completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)developmentPlanWithId:(int64_t)devPlanId
               withCompletion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)developmentPlansWithParams:(NSDictionary *)params
                        completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)updateDevelopmentPlanWithId:(int64_t)devPlanId
                             params:(NSDictionary *)params
                         completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;

- (void)addDevelopmentPlanGoalWithParams:(NSDictionary *)params
                                    link:(NSString *)link
                              completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)deleteDevelopmentPlanGoalWithLink:(NSString *)link
                               completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)updateDevelopmentPlanGoalWithParams:(NSDictionary *)params
                                       link:(NSString *)link
                                 completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;

- (void)addDevelopmentPlanGoalActionWithParams:(NSDictionary *)params
                                          link:(NSString *)link
                                    completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)deleteDevelopmentPlanGoalActionWithLink:(NSString *)link
                                     completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)updateDevelopmentPlanGoalActionWithParams:(NSDictionary *)params
                                             link:(NSString *)link
                                       completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;


@end
