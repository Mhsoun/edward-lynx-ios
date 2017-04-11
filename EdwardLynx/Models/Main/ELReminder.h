//
//  ELReminder.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 29/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELModel.h"

typedef NS_ENUM(NSInteger, kELReminderType) {
    kELReminderTypeFeedback,
    kELReminderTypeGoal,
    kELReminderTypeSurvey
};

@interface ELReminder : ELModel

@property (nonatomic) kELReminderType type;
@property (nonatomic) NSString<Optional> *name;
@property (nonatomic) NSString<Optional> *shortDescription;
@property (nonatomic) NSDate<Optional> *dueDate;

@property (nonatomic) NSMutableAttributedString<Ignore> *attributedDueDateInfo;
@property (nonatomic) NSString<Ignore> *dueDateInfo;

@end
