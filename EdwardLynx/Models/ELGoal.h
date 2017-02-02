//
//  ELGoal.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ELGoal : ELModel

@property (nonatomic) NSString *title;
@property (nonatomic) NSString<Optional> *shortDescription;
@property (nonatomic) BOOL checked;
@property (nonatomic) int64_t position;
@property (nonatomic) BOOL reminderSent;
@property (nonatomic) BOOL categoryChecked;
@property (nonatomic) BOOL dueDateChecked;
@property (nonatomic) NSString<Ignore> *category;
@property (nonatomic) NSDate<Optional> *dueDate;

@end
