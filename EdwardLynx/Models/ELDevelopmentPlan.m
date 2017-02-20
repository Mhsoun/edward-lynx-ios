//
//  ELDevelopmentPlan.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDevelopmentPlan.h"

@implementation ELDevelopmentPlan

@synthesize completed = _completed;
@synthesize progress = _progress;
@synthesize progressText = _progressText;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return [propertyName isEqualToString:@"progress"] || [propertyName isEqualToString:@"completed"];
}

- (BOOL)completed {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.checked == YES"];
    NSInteger completedGoals = [[self.goals filteredArrayUsingPredicate:predicate] count];
    
    return completedGoals == self.goals.count;
}

- (CGFloat)progress {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.checked == YES"];
    NSInteger completedGoals = [[self.goals filteredArrayUsingPredicate:predicate] count];
    
    return completedGoals / (CGFloat)self.goals.count;
}

- (NSString<Ignore> *)progressText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.checked == YES"];
    NSInteger completedGoals = [[self.goals filteredArrayUsingPredicate:predicate] count];
    
    return [NSString stringWithFormat:NSLocalizedString(@"kELCompletedLabel", nil),
            @(completedGoals),
            @(self.goals.count)];
}

@end
