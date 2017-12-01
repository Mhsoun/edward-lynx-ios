//
//  ELGoal.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELGoalAction.h"
#import "ELCategory.h"

@protocol ELGoalAction;

@interface ELGoal : ELModel

@property (nonatomic) int64_t position;
@property (nonatomic) int64_t categoryId;
@property (nonatomic) BOOL reminderSent;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString<Optional> *shortDescription;
@property (nonatomic) NSDate<Optional> *dueDate;
@property (nonatomic) NSDate<Ignore> *createdAt;
@property (nonatomic) NSArray<ELGoalAction, Optional> *actions;

/**
 Determines if goal has a category linked to it.
 */
@property (nonatomic) BOOL categoryChecked;
/**
 Determines if goal has achieved all its corresponding actions.
 */
@property (nonatomic) BOOL checked;
/**
 Determines if goal has a due date linked to it.
 */
@property (nonatomic) BOOL dueDateChecked;
@property (nonatomic) BOOL isAlreadyAdded;
/**
 Determines completion rate of goal based on its actions.
 */
@property (nonatomic) CGFloat progress;
/**
 Returns a formatted date of goal's due date as a string.
 */
@property (nonatomic) NSString<Ignore> *dueDateString;
/**
 Provides the API endpoint link for current goal (e.g. updating current goal).
 */
@property (nonatomic) NSString<Ignore> *urlLink;
/**
 A ELCategory instance based on goal's categoryId property.
 */
@property (nonatomic) ELCategory<Ignore> *category;

/**
 Provides the value and text details of goal's progress.

 @return A dictionary containing goal's progress details.
 */
- (NSDictionary *)progressDetails;

@end
