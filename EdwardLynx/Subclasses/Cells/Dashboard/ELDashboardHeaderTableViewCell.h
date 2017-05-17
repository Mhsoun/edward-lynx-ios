//
//  ELDashboardHeaderTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kELDashboardActionTypeDevPlan = @"TabDevPlan";
static NSString * const kELDashboardActionTypeFeedback = @"TabFeedback";
static NSString * const kELDashboardActionTypeLynx = @"TabLynx";

static NSString * const kELDashboardActionTypeAnswer = @"Feedback";
static NSString * const kELDashboardActionTypeReport = @"Report";
static NSString * const kELDashboardActionTypeCreate = @"Create";
static NSString * const kELDashboardActionTypeCreateDevPlan = @"CreateDevelopmentPlan";
static NSString * const kELDashboardActionTypeCreateFeedback = @"CreateInstantFeedback";

@class ELBaseViewController;

@interface ELDashboardHeaderTableViewCell : UITableViewCell<ELDashboardViewDelegate>

@property (nonatomic, weak) id<ELDashboardViewDelegate> delegate;

- (void)setupHeaderContent:(NSArray *)contents controller:(__kindof ELBaseViewController *)controller;

@end
