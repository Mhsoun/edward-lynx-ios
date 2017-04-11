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
@property (nonatomic) NSArray<Optional, ELReminder> *reminders;
@property (nonatomic) NSArray<Optional, ELDevelopmentPlan> *developmentPlans;

@end
