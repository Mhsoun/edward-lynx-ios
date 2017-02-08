//
//  ELGoal.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELGoalAction.h"

@protocol ELGoalAction;

@interface ELGoal : ELModel

@property (nonatomic) int64_t position;
@property (nonatomic) BOOL checked;
@property (nonatomic) BOOL reminderSent;
@property (nonatomic) BOOL categoryChecked;
@property (nonatomic) BOOL dueDateChecked;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString<Ignore> *category;
@property (nonatomic) NSString<Optional> *shortDescription;
@property (nonatomic) NSString<Ignore> *urlLink;
@property (nonatomic) NSDate<Optional> *dueDate;
@property (nonatomic) NSArray<ELGoalAction> *actions;

- (NSDictionary *)progressDetails;

@end