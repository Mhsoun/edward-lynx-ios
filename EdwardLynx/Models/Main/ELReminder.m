//
//  ELReminder.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 29/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELReminder.h"

@implementation ELReminder

@synthesize attributedDueDateInfo = _attributedDueDateInfo;
@synthesize dueDateInfo = _dueDateInfo;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id",
                                                                  @"dueDate": @"due",
                                                                  @"shortDescription": @"description"}];
}

- (void)setTypeWithNSString:(NSString *)type {
    if ([type isEqualToString:@"instant-feedback"]) {
        self.type = kELReminderTypeFeedback;
    } else if ([type isEqualToString:@"survey"]) {
        self.type = kELReminderTypeSurvey;
    } else {
        self.type = kELReminderTypeGoal;
    }
}

- (NSMutableAttributedString<Ignore> *)attributedDueDateInfo {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Bold" size:14],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSMutableAttributedString *info = [[NSMutableAttributedString alloc] initWithString:self.dueDateInfo
                                                                            attributes:attributes];
    
    if ([[info string] isEqualToString:NSLocalizedString(@"kELDashboardDueDateNow", nil)]) {
        [info addAttribute:NSForegroundColorAttributeName
                     value:ThemeColor(kELOrangeColor)
                     range:NSMakeRange(0, info.length)];
    } else {
        [info addAttribute:NSFontAttributeName
                     value:[UIFont fontWithName:@"Lato-Regular" size:10]
                     range:[[info string] rangeOfString:@"Due in"]];
    }
    
    return info;
}

- (NSString<Ignore> *)dueDateInfo {
    NSInteger days;
    NSDate *currentDate = [NSDate date];
    
    if (!self.dueDate) {
        return @"";
    }
    
    days = [currentDate mt_daysUntilDate:self.dueDate];
    
    if ([currentDate mt_isOnOrBefore:self.dueDate]) {
        NSString *key;
        
        if (days == 0) {
            return NSLocalizedString(@"kELDashboardDueDateNow", nil);
        }
        
        key = days == 1 ? @"kELDashboardDueDateMessageSingular" : @"kELDashboardDueDateMessagePlural";
        
        return [NSString stringWithFormat:NSLocalizedString(key, nil), @(days)];
    }
    
    return @"";
}

@end
