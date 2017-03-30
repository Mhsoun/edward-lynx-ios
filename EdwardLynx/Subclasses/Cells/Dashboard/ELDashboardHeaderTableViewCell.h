//
//  ELDashboardHeaderTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kELDashboardActionTypeDevPlan = @"DevPlan";
static NSString * const kELDashboardActionTypeFeedback = @"Feedback";
static NSString * const kELDashboardActionTypeLynx = @"Lynx";
static NSString * const kELDashboardActionTypeCreateDevPlan = @"CreateDevelopmentPlan";
static NSString * const kELDashboardActionTypeCreateFeedback = @"CreateInstantFeedback";

@class ELBaseViewController;

@interface ELDashboardHeaderTableViewCell : UITableViewCell<ELDashboardViewDelegate>

@property (nonatomic, strong) id<ELDashboardViewDelegate> delegate;

- (void)setupHeaderContentForController:(__kindof ELBaseViewController *)controller;

@end
