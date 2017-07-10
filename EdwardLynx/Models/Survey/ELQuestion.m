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
    return self.optional ? Format(NSLocalizedString(@"kELAnswerOptionalMessage", nil), _text) : _text;
}

- (void)setText:(NSString *)text {
    _text = text;
}

- (CGFloat)heightForQuestionView {
    switch (self.answer.type) {
        case kELAnswerTypeOneToTenWithExplanation:
        case kELAnswerTypeText:
            return 110;
        case kELAnswerTypeOneToFiveScale:
        case kELAnswerTypeOneToTenScale:
            return 20;
        default:
            return ((self.answer.options.count * kELCustomScaleItemHeight) +
                    (self.isNA ? kELCustomScaleItemHeight : 0));
    }
}

@end
