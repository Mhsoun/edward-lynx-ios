//
//  ELTeamDevelopmentPlan.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELTeamDevelopmentPlan.h"

@implementation ELTeamDevelopmentPlan

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id"}];
}

- (NSDictionary *)apiDictionary {
    return @{@"id": @(self.objectId),
             @"name": self.name,
             @"position": @(self.position),
             @"visible": @(self.visible)};
}

- (NSDictionary *)putDictionary {
    return @{@"id": @(self.objectId),
             @"position": @(self.position),
             @"visible": @(self.visible)};
}

@end

@implementation ELTeamDevelopmentPlanUser

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id"}];
}

@end

@implementation ELTeamDevelopmentPlanGoal

- (NSDictionary *)progressDetails {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.checked == YES"];
    NSInteger completedActions = [[self.actions filteredArrayUsingPredicate:predicate] count];
    
    return @{@"value": @(self.progress),
             @"text": Format(NSLocalizedString(@"kELCompletedLabel", nil),
                             @(completedActions),
                             @(self.actions.count))};
}

@end

@implementation ELTeamDevelopmentPlanAction

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id"}];
}

@end
