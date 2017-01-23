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
    NSMutableArray *mOptions = [NSMutableArray arrayWithArray:_question.answer.options];
    
    self.helpLabel.text = self.question.answer.help;
    
    // Segmented Control
    [self.scaleChoices removeAllSegments];
    
    if (_question.isNA) {
        [mOptions addObject:[[ELAnswerOption alloc] initWithDictionary:@{@"description": @"N/A", @"value": @(-1)}
                                                                 error:nil]];
    }
    
    for (int i = 0; i < [mOptions count]; i++) {
        ELAnswerOption *option = mOptions[i];
        
        [self.scaleChoices insertSegmentWithTitle:[NSString stringWithFormat:@"%@", option.shortDescription]
                                          atIndex:i
                                         animated:NO];
    }
    
    // Text View
    self.textView.hidden = _question.answer.type != kELAnswerTypeOneToTenWithExplanation;
}

#pragma mark - Public Methods

- (NSDictionary *)formValues {
    ELAnswerOption *option;
    
    if (!_question.optional && self.scaleChoices.selectedSegmentIndex < 0) {
        return nil;
    }
    
    option = _question.answer.options[self.scaleChoices.selectedSegmentIndex];
    
    return @{@"question": @(_question.objectId),
             @"answer": @(option.value)};
}

- (ELQuestion *)question {
    return _question;
}

- (void)setQuestion:(ELQuestion *)question {
    _question = question;
    
    [self setupNumberScale];
}

@end
