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
    
    if (!self.goals || self.goals.count == 0) {
        return averageProgress;
    }
    
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
    NSDictionary *attributesDict = @{NSFontAttributeName: Font(@"Lato-Bold", 12.0f),
                                     NSForegroundColorAttributeName: ThemeColor(kELOrangeColor)};
    
    completedGoals = [[self.goals filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.progress == 1"]] count];
    format = Format(NSLocalizedString(@"kELDevelopmentPlanGoalsCompleted", nil), @(completedGoals), @(self.goals.count));
    infoString = [[NSMutableAttributedString alloc] initWithString:format attributes:attributesDict];
    
    // TODO Change range due to localization
    [infoString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor whiteColor]
                       range:[format rangeOfString:NSLocalizedString(@"kELDevelopmentPlanCompleted", nil)]];
    [infoString addAttribute:NSFontAttributeName
                       value:Font(@"Lato-Regular", 12.0f)
                       range:[format rangeOfString:NSLocalizedString(@"kELDevelopmentPlanCompleted", nil)]];
    
    return infoString;
}

- (NSString<Ignore> *)progressText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.progress == 1"];
    NSInteger completedGoals = [[self.goals filteredArrayUsingPredicate:predicate] count];
    
    return Format(NSLocalizedString(@"kELCompletedLabel", nil),
                  @(completedGoals),
                  @(self.goals.count));
}

- (NSArray<Ignore> *)sortedGoals {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"progress" ascending:YES];
    
    return [self.goals sortedArrayUsingDescriptors:@[descriptor]];
}

@end
