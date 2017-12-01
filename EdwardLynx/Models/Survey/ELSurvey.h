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

@property (nonatomic) NSInteger invited;
@property (nonatomic) NSInteger answered;
@property (nonatomic) kELSurveyType type;
@property (nonatomic) kELSurveyStatus status;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *lang;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSString<Optional> *key;
@property (nonatomic) NSString<Optional> *evaluationText;
@property (nonatomic) NSString<Optional> *shortDescription;

/**
 Checks if the current date is already past survey's designated end time.
 */
@property (nonatomic) BOOL isExpired;

/**
 Format survey's end time as a readable string.
 */
@property (nonatomic) NSString<Ignore> *endDateString;
/**
 Format survey's start time as a readable string.
 */
@property (nonatomic) NSString<Ignore> *startDateString;

@end
