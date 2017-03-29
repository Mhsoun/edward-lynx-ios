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
    kELReminderTypeGoal
};

@interface ELReminder : ELModel

@property (nonatomic) kELReminderType type;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *shortDescription;
@property (nonatomic) NSDate *dueDate;

@property (nonatomic) NSMutableAttributedString<Ignore> *attributedDueDateInfo;
@property (nonatomic) NSString<Ignore> *dueDateInfo;

@end
