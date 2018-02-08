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
        NSString *rootURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:kELAPIClientPlistKey][@"URL"];
        ELDevelopmentPlan *devPlan = [[ELDevelopmentPlan alloc] initWithDictionary:devPlanDict error:nil];
        NSString *endpoint = Format(kELAPIDevelopmentPlanEndpoint,
                                    kELAPIVersionNamespace,
                                    @(devPlan.objectId));
        
        devPlan.urlLink = Format(@"%@/%@", rootURL, endpoint);
        
        [mDevPlans addObject:devPlan];
    }
    
    self.developmentPlans = [mDevPlans copy];
}

- (NSArray *)sections {
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
