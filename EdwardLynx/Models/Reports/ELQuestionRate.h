//
//  ELQuestionRate.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 01/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELAnswer.h"

@protocol ELAnswer;

@interface ELQuestionRate : JSONModel

@property (nonatomic) double candidates;
@property (nonatomic) double others;
@property (nonatomic) NSString *category;
@property (nonatomic) NSString *question;
@property (nonatomic) ELAnswer *answerType;

@end
