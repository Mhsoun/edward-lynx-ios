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

/**
 Provides the sections to be displayed in the Dashboard page.

 @return A list of section labels to be displayed.
 */
- (NSArray *)sections;
/**
 Provides the list of items to be displayed in a given section.

 @param section The section to check count.
 @return A list of items to be displayed.
 */
- (NSArray *)itemsForSection:(NSString *)section;

@end
