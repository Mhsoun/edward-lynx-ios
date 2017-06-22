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

@property (nonatomic) BOOL completed;
@property (nonatomic) CGFloat progress;
@property (nonatomic) NSAttributedString<Ignore> *attributedProgressText;
@property (nonatomic) NSString<Ignore> *progressText;
@property (nonatomic) NSArray<Ignore> *sortedGoals;

@end
