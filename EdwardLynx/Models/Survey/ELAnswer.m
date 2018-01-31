//
//  ELAnswer.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 04/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAnswer.h"

@implementation ELAnswer

@synthesize optionKeys = _optionKeys;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"shortDescription": @"description"}];
}

- (NSArray *)optionKeys {
    NSMutableArray *mKeys = [[NSMutableArray alloc] init];
    
    for (ELAnswerOption *option in self.options) {
        [mKeys addObject:option.shortDescription];
    }
    
    return [mKeys copy];
}

@end
