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
@property (nonatomic) NSString<Ignore> *category;  // TODO Change to id
@property (nonatomic) NSString<Ignore> *urlLink;
@property (nonatomic) NSString<Optional> *shortDescription;
@property (nonatomic) NSDate<Optional> *dueDate;

@property (nonatomic) BOOL isAlreadyAdded;
@property (nonatomic) CGFloat progress;
@property (nonatomic) NSArray<ELGoalAction, Optional> *actions;
@property (nonatomic) NSDate<Ignore> *createdAt;
@property (nonatomic) NSString<Ignore> *dueDateString;

- (NSDictionary *)progressDetails;

@end
