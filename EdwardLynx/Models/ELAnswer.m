//
//  ELAnswer.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 04/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAnswer.h"

@implementation ELAnswer

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"shortDescription": @"description"}];
}

@end