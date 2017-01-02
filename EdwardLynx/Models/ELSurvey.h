//
//  ELSurvey.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELQuestion.h"

@protocol ELQuestion;

@interface ELSurvey : JSONModel

@property (nonatomic) int64_t objectId;
@property (nonatomic) int64_t type;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *lang;
@property (nonatomic) NSString<Optional> *status;
@property (nonatomic) NSString *shortDescription;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSArray<ELQuestion> *questions;

@end
