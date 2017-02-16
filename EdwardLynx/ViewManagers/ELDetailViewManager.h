//
//  ELDetailViewManager.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 04/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

@class ELModel;

@interface ELDetailViewManager : NSObject

@property (nonatomic, strong) id<ELAPIResponseDelegate> delegate;

- (instancetype)initWithDetailObject:(__kindof ELModel *)detailObject;
- (instancetype)initWithObjectId:(int64_t)objectId;

- (void)processRetrievalOfDevelopmentPlanDetails;
- (void)processRetrievalOfInstantFeedbackDetails;
- (void)processRetrievalOfReportDetails;
- (void)processRetrievalOfSurveyDetails;
- (void)processRetrievalOfSurveyQuestions;

@end
