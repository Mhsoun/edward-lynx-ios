//
//  ELDevelopmentPlanViewManager.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

@interface ELDevelopmentPlanViewManager : NSObject

@property (nonatomic, strong) id<ELAPIPostResponseDelegate> delegate;

- (void)processCreateDevelopmentPlan:(NSDictionary *)formDict;
- (BOOL)validateAddGoalFormValues:(NSDictionary *)formDict;
- (BOOL)validateDevelopmentPlanFormValues:(NSDictionary *)formDict;

@end
