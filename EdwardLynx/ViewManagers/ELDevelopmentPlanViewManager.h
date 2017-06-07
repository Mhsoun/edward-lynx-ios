//
//  ELDevelopmentPlanViewManager.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

@interface ELDevelopmentPlanViewManager : NSObject

@property (nonatomic, weak) id<ELAPIPostResponseDelegate> delegate;

- (instancetype)initWithDetailObject:(__kindof ELModel *)detailObject;
- (instancetype)initWithObjectId:(int64_t)objectId;

- (void)processAddDevelopmentPlanGoal:(NSDictionary *)formDict;
- (void)processCreateDevelopmentPlan:(NSDictionary *)formDict;

- (void)processUpdateDevelopmentPlanGoal:(NSDictionary *)formDict;

- (void)processDeleteDevelopmentPlanGoalActionWithLink:(NSString *)link;
- (void)processUpdateDevelopmentPlanGoalAction:(NSDictionary *)formDict;

- (BOOL)validateAddGoalFormValues:(NSDictionary *)formDict;
- (BOOL)validateDevelopmentPlanFormValues:(NSDictionary *)formDict;

@end
