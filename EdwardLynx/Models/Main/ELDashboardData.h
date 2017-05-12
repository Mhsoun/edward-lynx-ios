//
//  ELDashboardData.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 10/04/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELDevelopmentPlan.h"
#import "ELReminder.h"

@protocol ELDevelopmentPlan;
@protocol ELReminder;

@interface ELDashboardData : JSONModel

@property (nonatomic) NSNumber<Optional> *answerableCount;
@property (nonatomic, strong) NSArray<Optional, ELReminder> *reminders;
@property (nonatomic, strong) NSArray<Optional, ELDevelopmentPlan> *developmentPlans;

- (NSArray *)sections;
- (NSArray *)itemsForSection:(NSString *)section;

@end
