//
//  ELYesNoData.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELYesNoData.h"

@implementation ELYesNoData

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id"}];
}

@end
