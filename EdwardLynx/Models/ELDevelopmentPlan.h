//
//  ELDevelopmentPlan.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELGoal.h"

#import <JSONModel/JSONModel.h>

@protocol ELGoal;

@interface ELDevelopmentPlan : ELModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSDate *updatedAt;
@property (nonatomic) NSArray<ELGoal> *goals;

@end
