//
//  ELDevelopmentPlan.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDevelopmentPlan.h"

@implementation ELDevelopmentPlan

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id"}];
}

- (NSDictionary *)progressDetails {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.checked == YES"];
    NSInteger completedGoals = [[self.goals filteredArrayUsingPredicate:predicate] count];
    
    return @{@"value": @(completedGoals / (CGFloat)self.goals.count),
             @"text": [NSString stringWithFormat:NSLocalizedString(@"kELCompletedLabel", nil),
                       @(completedGoals),
                       @(self.goals.count)]};
}

@end
