//
//  ELSurvey.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurvey.h"

@implementation ELSurvey

@synthesize startDateString = _startDateString;
@synthesize endDateString = _endDateString;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id",
                                                                  @"shortDescription": @"description",
                                                                  @"evaluationText": @"personsEvaluatedText"}];
}

- (NSString<Ignore> *)startDateString {
    return [AppSingleton.printDateFormatter stringFromDate:self.startDate];
}

- (NSString<Ignore> *)endDateString {
    return [AppSingleton.printDateFormatter stringFromDate:self.startDate];
}

@end
