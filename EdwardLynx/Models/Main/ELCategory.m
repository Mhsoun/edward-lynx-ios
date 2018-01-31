//
//  ELCategory.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELCategory.h"

@implementation ELCategory

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id",
                                                                  @"shortDescription": @"description"}];
}

@end
