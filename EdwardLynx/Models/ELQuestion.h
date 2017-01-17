//
//  ELQuestion.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELAnswer.h"
#import "ELModel.h"

@protocol ELAnswer;

@interface ELQuestion : ELModel

@property (nonatomic) NSString *text;
@property (nonatomic) BOOL optional;
@property (nonatomic) BOOL isNA;
@property (nonatomic) BOOL isFollowUpQuestion;
@property (nonatomic) ELAnswer *answer;

@end
