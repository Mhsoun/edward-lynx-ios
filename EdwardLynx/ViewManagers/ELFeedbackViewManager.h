//
//  ELFeedbackViewManager.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <REValidation/REValidation.h>

#import "ELSurveysAPIClient.h"

@interface ELFeedbackViewManager : NSObject

@property (strong, nonatomic) id<ELAPIResponseDelegate> delegate;

- (void)processInstantFeedback:(NSDictionary *)formDict;
- (void)processInstantFeedbackAnswerSubmissionAtId:(int64_t)objId
                                      withFormData:(NSDictionary *)formDict;
- (void)processSharingOfReportToUsers:(NSDictionary *)params
                                 atId:(int64_t)objId;

- (BOOL)validateCreateInstantFeedbackFormValues:(NSDictionary *)formDict;
- (BOOL)validateInstantFeedbackInviteUsersFormValues:(NSDictionary *)formDict;

@end
