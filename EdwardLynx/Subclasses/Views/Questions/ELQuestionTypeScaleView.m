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
    NSInteger index;
    BOOL isYesOrNo = _question.answer.type == kELAnswerTypeYesNoScale;
    BOOL isOneToTen = _question.answer.type != kELAnswerTypeOneToFiveScale;
    BOOL isOneToTenWithExplanation = _question.answer.type == kELAnswerTypeOneToTenWithExplanation;
    UIFont *font = [UIFont fontWithName:@"Lato-Regular" size:isOneToTen ? 10.0f : 13.0f];
    NSMutableArray *mOptions = [NSMutableArray arrayWithArray:_question.answer.options];
    
    // Segmented Control
    [self.scaleChoices removeAllSegments];
    [self.scaleChoices setTitleTextAttributes:@{NSFontAttributeName: font} forState:UIControlStateNormal];
    
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
    
    [self.topConstraint setConstant:!isOneToTenWithExplanation ? 25 : 0];
    [self.scaleChoices updateConstraints];
    
    // Populate question answer
    if ([_question.value integerValue] > -1) {
        index = [_question.value integerValue];
        
        [self.scaleChoices setSelectedSegmentIndex:isYesOrNo ? index : index - 1];
    }
    
    // Text View
    self.textView.hidden = !isOneToTenWithExplanation;
}

#pragma mark - Public Methods

- (NSDictionary *)formValues {
    ELAnswerOption *option;
    
    if (!_question.optional && self.scaleChoices.selectedSegmentIndex < 0) {
        return nil;
    }
    
    option = _question.answer.options[self.scaleChoices.selectedSegmentIndex];
    
    return @{@"question": @(_question.objectId),
             @"answer": (NSNumber *)option.value};
}

#pragma mark - Getter/Setter Methods

- (ELQuestion *)question {
    return _question;
}

- (void)setQuestion:(ELQuestion *)question {
    _question = question;
    
    [self setupNumberScale];
}

@end
