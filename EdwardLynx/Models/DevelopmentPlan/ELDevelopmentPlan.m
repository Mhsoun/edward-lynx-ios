//
//  ELDevelopmentPlan.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDevelopmentPlan.h"

@implementation ELDevelopmentPlan

@synthesize attributedProgressText = _attributedProgressText;
@synthesize completed = _completed;
@synthesize progress = _progress;
@synthesize progressText = _progressText;
@synthesize searchTitle = _searchTitle;
@synthesize sortedGoals = _sortedGoals;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return ([propertyName isEqualToString:@"progress"] ||
            [propertyName isEqualToString:@"completed"] ||
            [propertyName isEqualToString:@"searchTitle"]);
}

- (BOOL)completed {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.progress == 1"];
    NSInteger completedGoals = [[self.goals filteredArrayUsingPredicate:predicate] count];
    
    return completedGoals == self.goals.count;
}

- (CGFloat)progress {
    CGFloat averageProgress = 0;
    
    for (ELGoal *goal in self.goals) {
        averageProgress += goal.progress;
    }
    
    return averageProgress / (CGFloat)self.goals.count;
}

- (NSString *)searchTitle {
    return self.name;
}

- (NSAttributedString<Ignore> *)attributedProgressText {
    NSInteger completedGoals;
    NSString *format;
    NSMutableAttributedString *infoString;
    NSDictionary *attributesDict = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Bold" size:12.0f],
                                     NSForegroundColorAttributeName: [[RNThemeManager sharedManager] colorForKey:kELOrangeColor]};
    
    completedGoals = [[self.goals filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.progress == 1"]] count];
    format = [NSString stringWithFormat:@"%@ of %@ goals completed", @(completedGoals), @(self.goals.count)];
    infoString = [[NSMutableAttributedString alloc] initWithString:format attributes:attributesDict];
    
    [infoString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor whiteColor]
                       range:[format rangeOfString:@"completed"]];
    [infoString addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"Lato-Regular" size:12.0f]
                       range:[format rangeOfString:@"completed"]];
    
    return infoString;
}

- (NSString<Ignore> *)progressText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.progress == 1"];
    NSInteger completedGoals = [[self.goals filteredArrayUsingPredicate:predicate] count];
    
    return [NSString stringWithFormat:NSLocalizedString(@"kELCompletedLabel", nil),
            @(completedGoals),
            @(self.goals.count)];
}

- (NSArray<Ignore> *)sortedGoals {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"progress" ascending:YES];
    
    return [self.goals sortedArrayUsingDescriptors:@[descriptor]];
}

@end
