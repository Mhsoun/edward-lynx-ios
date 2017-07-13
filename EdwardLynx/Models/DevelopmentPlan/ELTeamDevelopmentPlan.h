//
//  ELTeamDevelopmentPlan.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELModel.h"
#import "ELGoal.h"

@protocol ELTeamDevelopmentPlanUser;
@protocol ELTeamDevelopmentPlanGoal;
@protocol ELTeamDevelopmentPlanAction;

@interface ELTeamDevelopmentPlan : ELModel

@property (nonatomic) int64_t ownerId;
@property (nonatomic) int64_t position;
@property (nonatomic) BOOL checked;
@property (nonatomic) BOOL visible;
@property (nonatomic) CGFloat progress;
@property (nonatomic) NSString *name;

- (NSDictionary *)apiDictionary;
- (NSDictionary *)putDictionary;

@end

@interface ELTeamDevelopmentPlanUser : ELModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSArray<ELTeamDevelopmentPlanGoal> *goals;

@end

@interface ELTeamDevelopmentPlanGoal : JSONModel

@property (nonatomic) CGFloat progress;
@property (nonatomic) NSString *title;
@property (nonatomic) NSArray<ELTeamDevelopmentPlanAction> *actions;

- (NSDictionary *)progressDetails;

@end

@interface ELTeamDevelopmentPlanAction : ELModel

@property (nonatomic) int64_t position;
@property (nonatomic) BOOL checked;
@property (nonatomic) NSString *title;

@end
