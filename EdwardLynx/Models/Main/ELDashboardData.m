//
//  ELDashboardData.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 10/04/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDashboardData.h"

@implementation ELDashboardData

- (void)setDevelopmentPlansWithNSArray:(NSArray<Optional,ELDevelopmentPlan> *)developmentPlans {
    NSMutableArray *mDevPlans = [[NSMutableArray alloc] init];
    
    for (NSDictionary *devPlanDict in developmentPlans) {
        ELDevelopmentPlan *devPlan = [[ELDevelopmentPlan alloc] initWithDictionary:devPlanDict error:nil];
        NSString *endpoint = [NSString stringWithFormat:kELAPIDevelopmentPlanEndpoint,
                              kELAPIVersionNamespace,
                              @(devPlan.objectId)];
        
        devPlan.urlLink = [NSString stringWithFormat:@"%@/%@", kELAPIRootEndpoint, endpoint];
        
        [mDevPlans addObject:devPlan];
    }
    
    self.developmentPlans = [mDevPlans copy];
}

- (NSArray *)sections {
    NSMutableArray *mSections = [[NSMutableArray alloc] init];
    
    [mSections addObject:@""];
    
    if (self.reminders && self.reminders.count > 0) {
        [mSections addObject:NSLocalizedString(@"kELDashboardSectionReminder", nil)];
    }
    
    if (self.developmentPlans && self.developmentPlans.count > 0) {
        [mSections addObject:NSLocalizedString(@"kELDashboardSectionDevelopmentPlan", nil)];
    }
    
    return [mSections copy];
}

- (NSArray *)itemsForSection:(NSString *)section {
    if ([section isEqualToString:NSLocalizedString(@"kELDashboardSectionReminder", nil)]) {
        return self.reminders;
    } else if ([section isEqualToString:NSLocalizedString(@"kELDashboardSectionDevelopmentPlan", nil)]) {
        return self.developmentPlans;
    } else {
        return @[self.answerableCount, @0, @0, @0];
    }
}

@end
