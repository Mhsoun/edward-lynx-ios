//
//  ELSurvey.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurvey.h"

@implementation ELSurvey

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id",
                                                                  @"shortDescription": @"description",
                                                                  @"evaluationText": @"personsEvaluatedText"}];
}

@end
