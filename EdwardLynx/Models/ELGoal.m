//
//  ELGoal.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELGoal.h"

@implementation ELGoal

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id",
                                                                  @"shortDescription": @"description"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return [propertyName isEqualToString:@"categoryChecked"] || [propertyName isEqualToString:@"dueDateChecked"];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return [propertyName isEqualToString:@"objectId"];
}

- (NSDictionary *)progressDetails {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.checked == YES"];
    NSInteger completedActions = [[self.actions filteredArrayUsingPredicate:predicate] count];
    
    return @{@"text": [NSString stringWithFormat:@"%@ / %@ Completed", @(completedActions), @(self.actions.count)],
             @"value": @(completedActions / (CGFloat)self.actions.count)};
}

- (NSDictionary *)toDictionary {
    NSMutableArray *mActions = [[NSMutableArray alloc] init];
    
    for (ELGoalAction *action in self.actions) [mActions addObject:[action apiGetDictionary]];
    
    return @{@"title": self.title,
             @"position": @(self.position),
             @"description": self.shortDescription,
             @"dueDate": [[ELAppSingleton sharedInstance].apiDateFormatter stringFromDate:self.dueDate],
             @"actions": [mActions copy]};
}

@end
