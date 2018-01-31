//
//  ELDevelopmentPlan.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELGoal.h"
#import "ELSearcheableModel.h"

@protocol ELGoal;

@interface ELDevelopmentPlan : ELSearcheableModel

@property (nonatomic) BOOL shared;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString<Ignore> *urlLink;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSDate *updatedAt;
@property (nonatomic) NSArray<ELGoal> *goals;

/**
 Determines if the development plan succeeded in reaching all of its goals.
 */
@property (nonatomic) BOOL completed;
/**
 Aggregate progress of a development plan's goals and its actions.
 */
@property (nonatomic) CGFloat progress;
/**
 Formats the progress as (completed) of (goals) completed, with additional styling (e.g. used in Development Plan Details page).
 */
@property (nonatomic) NSAttributedString<Ignore> *attributedProgressText;
/**
 Formats the progress as "(completed) / (goals) Completed" string (e.g. used in Development Plan List page rows).
 */
@property (nonatomic) NSString<Ignore> *progressText;
/**
 Sort goals based on their progress in ascending order.
 */
@property (nonatomic) NSArray<Ignore> *sortedGoals;

@end
