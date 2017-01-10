//
//  ELDetailViewManager.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 04/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveysAPIClient.h"

@interface ELDetailViewManager : NSObject

@property (nonatomic, strong) id<ELAPIResponseDelegate> delegate;

- (void)processRetrievalOfSurveyQuestionsAtId:(int64_t)objId;
- (void)processAnswerSubmissionForSurveyId:(int64_t)surveyId withFormData:(NSDictionary *)formDict;

@end
