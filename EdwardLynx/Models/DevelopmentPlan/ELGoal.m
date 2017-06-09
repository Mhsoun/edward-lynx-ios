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
@synthesize category = _category;
@synthesize categoryChecked = _categoryChecked;
@synthesize dueDateChecked = _dueDateChecked;
@synthesize dueDateString = _dueDateString;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id",
                                                                  @"shortDescription": @"description"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return ([propertyName isEqualToString:@"categoryChecked"] ||
            [propertyName isEqualToString:@"dueDateChecked"] ||
            [propertyName isEqualToString:@"isAlreadyAdded"] ||
            [propertyName isEqualToString:@"progress"]);
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return [propertyName isEqualToString:@"objectId"] || [propertyName isEqualToString:@"categoryId"];
}

- (NSDictionary *)toDictionary {
    NSMutableArray *mActions = [[NSMutableArray alloc] init];
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"title": self.title,
                                                                                   @"description": self.shortDescription}];
    
    for (ELGoalAction *action in self.actions) [mActions addObject:[action apiGetDictionary]];
    
    if (self.dueDate) {
        [mDict setObject:[AppSingleton.apiDateFormatter stringFromDate:self.dueDate] forKey:@"dueDate"];
    }
    
    if (self.categoryId) {
        [mDict setObject:@(self.categoryId) forKey:@"categoryId"];
    }
    
    if (self.position) {
        [mDict setObject:@(self.position) forKey:@"position"];
    }
    
    [mDict setObject:[mActions copy] forKey:@"actions"];
    
    return [mDict copy];
}

- (ELCategory<Ignore> *)category {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", @(self.categoryId)];
    NSArray *filteredArray = [AppSingleton.categories filteredArrayUsingPredicate:predicate];
    
    if (filteredArray.count == 0) {
        return nil;
    }
    
    return filteredArray[0];
}

- (void)setCategory:(ELCategory<Ignore> *)category {
    _category = category;
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

- (BOOL)categoryChecked {
    return self.categoryId && self.categoryId > 0;
}

- (void)setCategoryChecked:(BOOL)categoryChecked {
    _categoryChecked = categoryChecked;
}

- (BOOL)dueDateChecked {
    return self.dueDate ? YES : NO;
}

- (void)setDueDateChecked:(BOOL)dueDateChecked {
    _dueDateChecked = dueDateChecked;
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
