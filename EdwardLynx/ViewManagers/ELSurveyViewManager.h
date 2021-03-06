//
//  ELSurveyViewManager.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

@class ELSurvey;

@interface ELSurveyViewManager : NSObject

@property (nonatomic, weak) id<ELAPIPostResponseDelegate> delegate;

- (instancetype)initWithSurvey:(ELSurvey *)survey;

- (void)processInviteOthersToRateYouWithParams:(NSDictionary *)formDict;
- (void)processSurveyAnswerSubmissionWithFormData:(NSDictionary *)formDict;
- (BOOL)validateAddInviteUserFormValues:(NSDictionary *)formDict;

@end
