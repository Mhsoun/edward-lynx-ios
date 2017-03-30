//
//  ELQuestion.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestion.h"

@implementation ELQuestion

@synthesize heightForQuestionView = _heightForQuestionView;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return [propertyName isEqualToString:@"heightForQuestionView"];
}

- (CGFloat)heightForQuestionView {
    // TODO Add another condition for One to Ten w/explanation
    return self.answer.type != kELAnswerTypeText ? ((self.answer.options.count * kELCustomScaleItemHeight) +
                                                    (self.isNA ? kELCustomScaleItemHeight : 0) +
                                                    kELCustomScaleItemHeight) : 110;
}

@end
