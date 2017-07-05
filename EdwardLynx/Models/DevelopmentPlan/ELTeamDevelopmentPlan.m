//
//  ELTeamDevelopmentPlan.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELTeamDevelopmentPlan.h"

@implementation ELTeamDevelopmentPlan

@synthesize progress = _progress;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return [propertyName isEqualToString:@"progress"];
}

- (CGFloat)progress {
    CGFloat averageProgress = 0;
    
    if (!self.goals || self.goals.count == 0) {
        return averageProgress;
    }
    
    for (ELGoal *goal in self.goals) {
        averageProgress += goal.progress;
    }
    
    return averageProgress / (CGFloat)self.goals.count;
}

- (NSDictionary *)apiDictionary {
    return @{@"name": self.name,
             @"position": @(self.position),
             @"visible": @(self.visible)};
}

@end
