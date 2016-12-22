//
//  ELUser.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELUser.h"

@implementation ELUser

- (NSArray *)permissionsByRole {
    if ([self.type isEqualToString:kELUserRoleSuperAdmin] || [self.type isEqualToString:kELUserRoleAdmin]) {
        return @[@(kELRolePermissionParticipateInSurvey),
                 @(kELRolePermissionSelectFeedbackProviders),
                 @(kELRolePermissionSubmitSurvey),
                 @(kELRolePermissionManage),
                 @(kELRolePermissionViewAnonymousIndividualReports),
                 @(kELRolePermissionViewAnonymousTeamReports),
                 @(kELRolePermissionCreateDevelopmentPlan),
                 @(kELRolePermissionCreateGoals),
                 @(kELRolePermissionInstantFeedback)];
    } else if ([self.type isEqualToString:kELUserRoleSupervisor]) {
        return @[@(kELRolePermissionViewAnonymousIndividualReports),  // NOTE Only user's direct reports
                 @(kELRolePermissionViewAnonymousTeamReports),  // NOTE Only user's team
                 @(kELRolePermissionInstantFeedback)];
    } else if ([self.type isEqualToString:kELUserRoleParticipant]) {
        return @[@(kELRolePermissionParticipateInSurvey),
                 @(kELRolePermissionSelectFeedbackProviders),
                 @(kELRolePermissionSubmitSurvey),
                 @(kELRolePermissionViewAnonymousIndividualReports),  // NOTE Only user's own
                 @(kELRolePermissionCreateDevelopmentPlan),
                 @(kELRolePermissionCreateGoals),
                 @(kELRolePermissionInstantFeedback)];
    } else if ([self.type isEqualToString:kELUserRoleFeedbackProvider]) {
        return @[@(kELRolePermissionParticipateInSurvey),
                 @(kELRolePermissionSubmitSurvey),
                 @(kELRolePermissionInstantFeedback)];
    } else if ([self.type isEqualToString:kELUserRoleAnalyst]) {
        return @[@(kELRolePermissionViewAnonymousIndividualReports),
                 @(kELRolePermissionViewAnonymousTeamReports),
                 @(kELRolePermissionInstantFeedback)];
    } else {
        return nil;
    }
}

@end
