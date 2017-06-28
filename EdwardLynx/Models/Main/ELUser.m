//
//  ELUser.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELUser.h"

@implementation ELUser

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id"}];
}

- (BOOL)isAdmin {
    return [@[kELUserRoleSuperAdmin,
              kELUserRoleAdmin,
              kELUserRoleSupervisor] containsObject:self.type];
}

- (BOOL)isNotAdminDevPlan {
    return [self isAdmin] && AppSingleton.devPlanUserId > -1;
}

- (NSSet *)permissionsByRole {
    NSArray *permissionsList;
    
    if ([self.type isEqualToString:kELUserRoleSuperAdmin] || [self.type isEqualToString:kELUserRoleAdmin]) {
        permissionsList = @[@(kELRolePermissionParticipateInSurvey),
                            @(kELRolePermissionSelectFeedbackProviders),
                            @(kELRolePermissionSubmitSurvey),
                            @(kELRolePermissionManage),
                            @(kELRolePermissionViewAnonymousIndividualReports),
                            @(kELRolePermissionViewAnonymousTeamReports),
                            @(kELRolePermissionCreateDevelopmentPlan),
                            @(kELRolePermissionCreateGoals),
                            @(kELRolePermissionInstantFeedback)];
    } else if ([self.type isEqualToString:kELUserRoleSupervisor]) {
        permissionsList = @[@(kELRolePermissionViewAnonymousIndividualReports),  // NOTE Only user's direct reports
                            @(kELRolePermissionViewAnonymousTeamReports),  // NOTE Only user's team
                            @(kELRolePermissionInstantFeedback)];
    } else if ([self.type isEqualToString:kELUserRoleParticipant]) {
        permissionsList = @[@(kELRolePermissionParticipateInSurvey),
                            @(kELRolePermissionSelectFeedbackProviders),
                            @(kELRolePermissionSubmitSurvey),
                            @(kELRolePermissionViewAnonymousIndividualReports),  // NOTE Only user's own
                            @(kELRolePermissionCreateDevelopmentPlan),
                            @(kELRolePermissionCreateGoals),
                            @(kELRolePermissionInstantFeedback)];
    } else if ([self.type isEqualToString:kELUserRoleFeedbackProvider]) {
        permissionsList = @[@(kELRolePermissionParticipateInSurvey),
                            @(kELRolePermissionSubmitSurvey),
                            @(kELRolePermissionInstantFeedback)];
    } else if ([self.type isEqualToString:kELUserRoleAnalyst]) {
        permissionsList = @[@(kELRolePermissionViewAnonymousIndividualReports),
                            @(kELRolePermissionViewAnonymousTeamReports),
                            @(kELRolePermissionInstantFeedback)];
    } else {
        return nil;
    }
    
    return [NSSet setWithArray:permissionsList];
}

@end
