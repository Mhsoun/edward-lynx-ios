//
//  ELQuestionsAPIClient.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAPIClient.h"

@interface ELQuestionsAPIClient : ELAPIClient

- (void)createQuestionWithParams:(NSDictionary *)params
                      completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;
- (void)updateQuestionForId:(int64_t)questionId
                     params:(NSDictionary *)params
                 completion:(void (^)(NSURLResponse *response, NSDictionary *responseDict, NSError *error))completion;

@end
