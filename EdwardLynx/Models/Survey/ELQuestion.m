//
//  ELQuestion.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestion.h"

@implementation ELQuestion

@synthesize text = _text;
@synthesize heightForQuestionView = _heightForQuestionView;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return [propertyName isEqualToString:@"heightForQuestionView"];
}

- (NSString *)text {
    return self.optional ? [NSString stringWithFormat:@"%@ (Optional)", _text] : _text;
}

- (void)setText:(NSString *)text {
    _text = text;
}

- (CGFloat)heightForQuestionView {
    switch (self.answer.type) {
        case kELAnswerTypeText:
            return 110;
            
            break;
        case kELAnswerTypeOneToTenWithExplanation:
            return ((self.answer.options.count * kELCustomScaleItemHeight) +
                    (self.isNA ? kELCustomScaleItemHeight : 0) + 100);
            
            break;
        default:
            return ((self.answer.options.count * kELCustomScaleItemHeight) +
                    (self.isNA ? kELCustomScaleItemHeight : 0) + kELCustomScaleItemHeight);
            
            break;
    }
}

@end
