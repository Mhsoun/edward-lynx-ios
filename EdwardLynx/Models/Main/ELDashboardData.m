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
        NSString *endpoint = Format(kELAPIDevelopmentPlanEndpoint,
                                    kELAPIVersionNamespace,
                                    @(devPlan.objectId));
        
        devPlan.urlLink = Format(@"%@/%@", kELAPIRootEndpoint, endpoint);
        
        [mDevPlans addObject:devPlan];
    }
    
    self.developmentPlans = [mDevPlans copy];
}

- (NSArray *)sections {
    NSMutableArray *mSections = [[NSMutableArray alloc] init];
    
    [mSections addObject:@""];
    
    if (self.reminders && self.reminders.count > 0) {
        [mSections addObject:NSLocalizedString(@"kELDashboardSectionReminders", nil)];
    }
    
    if (self.developmentPlans && self.developmentPlans.count > 0) {
        [mSections addObject:NSLocalizedString(@"kELDashboardSectionDevelopmentPlans", nil)];
    }
    
    // NOTE To display only the section with data
//    return [mSections copy];
    
    return @[@"",
             NSLocalizedString(@"kELDashboardSectionReminders", nil),
             NSLocalizedString(@"kELDashboardSectionDevelopmentPlans", nil)];
}

- (NSArray *)itemsForSection:(NSString *)section {
    if ([section isEqualToString:NSLocalizedString(@"kELDashboardSectionReminders", nil)]) {
        return self.reminders;
    } else if ([section isEqualToString:NSLocalizedString(@"kELDashboardSectionDevelopmentPlans", nil)]) {
        return self.developmentPlans.count > 2 ? [self.developmentPlans subarrayWithRange:NSMakeRange(0, 2)] :
                                                 self.developmentPlans;
    } else {
        NSInteger count = self.answerableCount ? [self.answerableCount integerValue] : 0;
        
        return @[@(count), @0, @0, @0];
    }
}

@end
