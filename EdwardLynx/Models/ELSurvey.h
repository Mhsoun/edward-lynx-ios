//
//  ELSurvey.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELModel.h"

@interface ELSurvey : ELModel

@property (nonatomic) int64_t type;
@property (nonatomic) kELSurveyStatus status;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *lang;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSString *shortDescription;
@property (nonatomic) NSString<Optional> *key;

@end
