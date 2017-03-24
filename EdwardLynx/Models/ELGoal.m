//
//  ELGoal.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELGoal.h"

@implementation ELGoal

@synthesize progress = _progress;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id",
                                                                  @"shortDescription": @"description"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return ([propertyName isEqualToString:@"categoryChecked"] ||
            [propertyName isEqualToString:@"dueDateChecked"] ||
            [propertyName isEqualToString:@"progress"]);
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return [propertyName isEqualToString:@"objectId"];
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

- (CGFloat)progress {
    NSInteger checked = 0;
    
    if (!self.actions) {
        return checked;
    }
    
    for (ELGoalAction *action in self.actions) {
        if (action.checked) {
            checked++;
        }
    }
    
    return checked / (CGFloat)self.actions.count;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
}

- (void)setActionsWithNSArray:(NSArray<ELGoalAction,Optional> *)actions {
    NSMutableArray *mActions;
    
    if (![[actions firstObject] class]) {
        self.actions = nil;
        
        return;
    }
    
    mActions = [[NSMutableArray alloc] init];
    
    for (NSDictionary *actionDict in actions) {
        [mActions addObject:[[ELGoalAction alloc] initWithDictionary:actionDict error:nil]];
    }
    
    self.actions = [mActions copy];
}

- (NSDictionary *)progressDetails {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.checked == YES"];
    NSInteger completedActions = [[self.actions filteredArrayUsingPredicate:predicate] count];
    
    return @{@"value": @(completedActions / (CGFloat)self.actions.count),
             @"text": [NSString stringWithFormat:NSLocalizedString(@"kELCompletedLabel", nil),
                       @(completedActions),
                       @(self.actions.count)]};
}


@end
