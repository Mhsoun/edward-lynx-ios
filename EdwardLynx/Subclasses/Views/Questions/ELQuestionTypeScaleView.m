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

- (instancetype)initWithFormKey:(NSString *)key {
    return [super initWithNibName:@"QuestionTypeScaleView" valueKey:key];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // TODO UI Implementation
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
    
    // Text View
    self.textView.hidden = _question.answer.type != kELAnswerTypeOneToTenWithExplanation;
}

#pragma mark - Public Methods

- (NSDictionary *)formValues {
    return @{};
}

- (ELQuestion *)question {
    return _question;
}

- (void)setQuestion:(ELQuestion *)question {
    _question = question;
    
    [self setupNumberScale];
}

@end
