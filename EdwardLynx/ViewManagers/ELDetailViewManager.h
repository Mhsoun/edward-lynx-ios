//
//  ELDetailViewManager.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 04/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELModel.h"
#import "ELSurveysAPIClient.h"

@interface ELDetailViewManager : NSObject

@property (nonatomic, strong) id<ELAPIResponseDelegate> delegate;

- (instancetype)initWithDetailObject:(__kindof ELModel *)detailObject;

- (void)processRetrievalOfReportDetails;
- (void)processRetrievalOfSurveyQuestions;

@end
