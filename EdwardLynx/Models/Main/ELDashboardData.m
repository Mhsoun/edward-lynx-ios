//
//  ELDashboardData.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 10/04/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDashboardData.h"

@implementation ELDashboardData

- (NSDictionary *)toDictionary {
    return @{@"": @[self.answerableCount, @(0), @(0), @(0)],
             @"REMINDERS": self.reminders,
             @"DEVELOPMENT PLAN": self.developmentPlans};
}

@end
