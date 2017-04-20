//
//  ELGoal.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELGoal.h"

@implementation ELGoal

@synthesize checked = _checked;
@synthesize progress = _progress;
@synthesize dueDateString = _dueDateString;

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
             @"dueDate": [AppSingleton.apiDateFormatter stringFromDate:self.dueDate],
             @"actions": [mActions copy]};
}

- (BOOL)checked {
    if (_checked) {
        return _checked;
    }
    
    return _progress == 1.0f;
}

- (void)setChecked:(BOOL)checked {
    _checked = checked;
}

- (NSString<Ignore> *)dueDateString {
    return [AppSingleton.printDateFormatter stringFromDate:self.dueDate];
}

- (void)setDueDateString:(NSString<Ignore> *)dueDateString {
    _dueDateString = dueDateString;
}

- (CGFloat)progress {
    NSInteger checked = 0;
    
    if (!self.actions || self.actions.count == 0) {
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
    
    return @{@"value": @(self.progress),
             @"text": [NSString stringWithFormat:NSLocalizedString(@"kELCompletedLabel", nil),
                       @(completedActions),
                       @(self.actions.count)]};
}


@end
