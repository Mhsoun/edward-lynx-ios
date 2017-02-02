//
//  ELDevelopmentPlanViewManager.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <REValidation/REValidation.h>

#import "ELDevelopmentPlanAPIClient.h"

#pragma mark - Public Constants

static NSString * const kELNoCategorySelected = @"No category selected";

@interface ELDevelopmentPlanViewManager : NSObject

@property (nonatomic, strong) id<ELAPIPostResponseDelegate> delegate;

- (void)processCreateDevelopmentPlan:(NSDictionary *)formDict;
- (BOOL)validateAddGoalFormValues:(NSDictionary *)formDict;
- (BOOL)validateDevelopmentPlanFormValues:(NSDictionary *)formDict;

@end
