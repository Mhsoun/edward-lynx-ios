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
    NSMutableAttributedString *info;
    NSDictionary *attributes = @{NSFontAttributeName: Font(@"Lato-Regular", 14.0f),
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    info = [[NSMutableAttributedString alloc] initWithString:self.dueDateInfo attributes:attributes];
    
    if ([[info string] isEqualToString:NSLocalizedString(@"kELDashboardDueDateNow", nil)]) {
        [info addAttribute:NSForegroundColorAttributeName
                     value:ThemeColor(kELOrangeColor)
                     range:NSMakeRange(0, info.length)];
    } else {
        [info addAttribute:NSFontAttributeName
                     value:Font(@"Lato-Regular", 10.0f)
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
        NSString *text;
        
        if (days == 0) {
            return NSLocalizedString(@"kELDashboardDueDateNow", nil);
        }
        
        text = days == 1 ? NSLocalizedString(@"kELDashboardDueDateMessageSingular", nil) :
                           NSLocalizedString(@"kELDashboardDueDateMessagePlural", nil);
        
        return Format(text, @(days));
    }
    
    return @"";
}

@end
