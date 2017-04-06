//
//  ELSurvey.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELSearcheableModel.h"

@interface ELSurvey : ELSearcheableModel

@property (nonatomic) kELSurveyType type;
@property (nonatomic) kELSurveyStatus status;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *lang;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSString<Optional> *key;
@property (nonatomic) NSString<Optional> *evaluationText;
@property (nonatomic) NSString<Optional> *shortDescription;

@property (nonatomic) NSString<Ignore> *startDateString;
@property (nonatomic) NSString<Ignore> *endDateString;

@end
