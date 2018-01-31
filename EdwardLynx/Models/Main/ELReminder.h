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
@property (nonatomic) NSString<Optional> *key;
@property (nonatomic) NSDate<Optional> *dueDate;

/**
 Returns dueDateInfo with additional styling.
 */
@property (nonatomic) NSMutableAttributedString<Ignore> *attributedDueDateInfo;
/**
 Returns a humanized due date information in terms of days (hours if time is less that a day before due date).
 */
@property (nonatomic) NSString<Ignore> *dueDateInfo;

@end
