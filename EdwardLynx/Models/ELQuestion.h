//
//  ELQuestion.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELAnswer.h"

@protocol ELAnswer;

@interface ELQuestion : JSONModel

@property (nonatomic) int64_t objectId;
@property (nonatomic) NSString *text;
@property (nonatomic) BOOL optional;
@property (nonatomic) BOOL isNA;
@property (nonatomic) BOOL isFollowUpQuestion;
@property (nonatomic) ELAnswer *answer;
@property (nonatomic) int64_t order;

@end
