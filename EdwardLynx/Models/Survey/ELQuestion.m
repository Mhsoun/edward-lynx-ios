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
    switch (self.answer.type) {
        case kELAnswerTypeText:
            return 100;
            break;
        case kELAnswerTypeOneToTenWithExplanation:
            return ((self.answer.options.count * kELCustomScaleItemHeight) +
                    (self.isNA ? kELCustomScaleItemHeight : 0) +
                    kELCustomScaleItemHeight) + 100;
            
            break;
        default:
            return ((self.answer.options.count * kELCustomScaleItemHeight) +
                    (self.isNA ? kELCustomScaleItemHeight : 0) +
                    kELCustomScaleItemHeight);
            
            break;
    }
}

@end
