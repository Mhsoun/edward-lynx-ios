//
//  ELListViewManager.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 04/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDevelopmentPlanAPIClient.h"
#import "ELSurveysAPIClient.h"

@interface ELListViewManager : NSObject

@property (nonatomic, strong) id<ELAPIResponseDelegate> delegate;

- (void)processRetrievalOfInstantFeedbacks;
- (void)processRetrievalOfDevelopmentPlans;
- (void)processRetrievalOfReports;
- (void)processRetrievalOfSurveys;

@end
