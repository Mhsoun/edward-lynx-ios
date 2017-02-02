//
//  ELAnswer.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 04/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELAnswerOption.h"

@protocol ELAnswerOption;

@interface ELAnswer : JSONModel

@property (nonatomic) kELAnswerType type;
@property (nonatomic) NSString<Optional> *shortDescription;
@property (nonatomic) NSString *help;
@property (nonatomic) BOOL isText;
@property (nonatomic) BOOL isNumeric;
@property (nonatomic) NSArray<Optional, ELAnswerOption> *options;

@end
