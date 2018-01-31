//
//  ELQuestion.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELModel.h"
#import "ELAnswer.h"

@protocol ELAnswer;

@interface ELQuestion : ELModel

@property (nonatomic) BOOL isNA;
@property (nonatomic) BOOL optional;
@property (nonatomic) BOOL isFollowUpQuestion;
@property (nonatomic) ELAnswer *answer;
@property (nonatomic) NSString<Optional> *explanation;
@property (nonatomic) NSString<Optional> *value;

/**
 Returns the question text with added logic for checking if it is optional, thus adding an "Optional" string if necessary.
 */
@property (nonatomic) NSString *text;
/**
 Returns the desired height for a given question type to be used on its question view.
 */
@property (nonatomic) CGFloat heightForQuestionView;

@end
