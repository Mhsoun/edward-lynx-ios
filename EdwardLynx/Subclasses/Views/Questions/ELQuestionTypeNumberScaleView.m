//
//  ELQuestionTypeNumberScaleView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 05/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestionTypeNumberScaleView.h"

@implementation ELQuestionTypeNumberScaleView

@synthesize question = _question;

#pragma mark - Lifecycle

- (instancetype)initWithFormKey:(NSString *)key {
    return [super initWithNibName:@"QuestionTypeNumberScaleView" valueKey:key];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // TODO UI Implementation
}

#pragma mark - Private Methods

- (void)setupNumberScale {
    [self.scaleChoices removeAllSegments];
    
    for (int i = 0; i < [_question.answer.options count]; i++) {
        ELAnswerOption *option = _question.answer.options[i];
        
        [self.scaleChoices insertSegmentWithTitle:[NSString stringWithFormat:@"%@", @(option.value)]
                                         atIndex:i
                                        animated:NO];
    }
    
    [self.scaleChoices setSelectedSegmentIndex:0];
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
