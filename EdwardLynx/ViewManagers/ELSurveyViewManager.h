//
//  ELSurveyViewManager.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurvey.h"
#import "ELSurveysAPIClient.h"

@interface ELSurveyViewManager : NSObject

@property (nonatomic, strong) id<ELAPIPostResponseDelegate> delegate;

- (instancetype)initWithSurvey:(ELSurvey *)survey;
- (void)processSurveyAnswerSubmissionWithFormData:(NSDictionary *)formDict;

@end
