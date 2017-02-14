//
//  ELFeedbackViewManager.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#pragma mark - Public Constants

static NSString * const kELNoQuestionType = @"No type selected";

@interface ELFeedbackViewManager : NSObject

@property (strong, nonatomic) id<ELAPIPostResponseDelegate> delegate;

- (void)processInstantFeedback:(NSDictionary *)formDict;
- (void)processInstantFeedbackAnswerSubmissionAtId:(int64_t)objId
                                      withFormData:(NSDictionary *)formDict;
- (void)processSharingOfReportToUsers:(NSDictionary *)params
                                 atId:(int64_t)objId;

- (BOOL)validateCreateInstantFeedbackFormValues:(NSDictionary *)formDict;

@end
