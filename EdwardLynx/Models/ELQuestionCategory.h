//
//  ELQuestionCategory.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 04/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELQuestion.h"

@protocol ELQuestion;

@interface ELQuestionCategory : JSONModel

@property (nonatomic) int64_t objectId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *shortDescription;
@property (nonatomic) BOOL isSurvey;
@property (nonatomic) int64_t order;
@property (nonatomic) NSArray<ELQuestion> *questions;

@end
