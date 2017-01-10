//
//  ELQuestionTypeScaleView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 05/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestionTypeScaleView.h"

@implementation ELQuestionTypeScaleView

@synthesize question = _question;

#pragma mark - Lifecycle

- (instancetype)init {
    return [super initWithNibName:@"QuestionTypeScaleView"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Private Methods

- (void)setupNumberScale {
    // Segmented Control
    [self.scaleChoices removeAllSegments];
    
    for (int i = 0; i < [_question.answer.options count]; i++) {
        ELAnswerOption *option = _question.answer.options[i];
        
        [self.scaleChoices insertSegmentWithTitle:[NSString stringWithFormat:@"%@", option.shortDescription]
                                          atIndex:i
                                         animated:NO];
    }
    
    [self.scaleChoices setSelectedSegmentIndex:0];
//    [self.scaleChoices setSelectedSegmentIndex:_question.isNA ? -1 : 0];
    
    // Text View
    self.textView.hidden = _question.answer.type != kELAnswerTypeOneToTenWithExplanation;
}

#pragma mark - Public Methods

- (NSDictionary *)formValues {
    ELAnswerOption *option;
    int64_t value = -1;
    
    if (!_question.isNA) {
        option = _question.answer.options[self.scaleChoices.selectedSegmentIndex];
        value = option.value;
    }
    
    return @{@"question": @(_question.objectId),
             @"answer": @(value)};
}

- (ELQuestion *)question {
    return _question;
}

- (void)setQuestion:(ELQuestion *)question {
    _question = question;
    
    [self setupNumberScale];
}

@end
