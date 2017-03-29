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
    
    if ([[info string] isEqualToString:@"Now"]) {
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
    
    if ([self.dueDate mt_isBefore:currentDate]) {
        return [NSString stringWithFormat:@"Due in \n%@ Days", @([self.dueDate mt_daysUntilDate:currentDate])];
    } else {
        return @"Now";
    }
}

@end
