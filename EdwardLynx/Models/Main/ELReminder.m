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
                                                                  @"shortDescription": @"description"}];
}


- (NSMutableAttributedString<Ignore> *)attributedDueDateInfo {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Bold" size:14],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSMutableAttributedString *info = [[NSMutableAttributedString alloc] initWithString:self.dueDateInfo
                                                                            attributes:attributes];
    
    if ([[info string] isEqualToString:NSLocalizedString(@"kELDashboardDueDateNow", nil)]) {
        [info addAttribute:NSForegroundColorAttributeName
                     value:[[RNThemeManager sharedManager] colorForKey:kELOrangeColor]
                     range:NSMakeRange(0, info.length)];
    } else {
        [info addAttribute:NSFontAttributeName
                     value:[UIFont fontWithName:@"Lato-Regular" size:10]
                     range:[[info string] rangeOfString:@"Due in"]];
    }
    
    return info;
}

- (NSString<Ignore> *)dueDateInfo {
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate mt_isBefore:self.dueDate]) {
        return [NSString stringWithFormat:NSLocalizedString(@"kELDashboardDueDateMessage", nil),
                @([currentDate mt_daysUntilDate:self.dueDate])];
    } else {
        return NSLocalizedString(@"kELDashboardDueDateNow", nil);
    }
}

@end
