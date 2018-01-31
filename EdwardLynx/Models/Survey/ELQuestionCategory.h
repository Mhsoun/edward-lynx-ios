//
//  ELQuestionCategory.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 04/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELModel.h"
#import "ELQuestion.h"

@protocol ELQuestion;

@interface ELQuestionCategory : ELModel

@property (nonatomic) int64_t order;
@property (nonatomic) NSString *title;
@property (nonatomic) NSArray<ELQuestion> *questions;
@property (nonatomic) NSString<Optional> *shortDescription;

@end
