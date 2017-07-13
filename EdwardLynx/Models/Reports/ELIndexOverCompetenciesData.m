//
//  ELIndexOverCompetenciesData.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 11/07/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELIndexOverCompetenciesData.h"

@implementation ELIndexOverCompetenciesData

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id"}];
}

@end
