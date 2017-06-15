//
//  ELQuestionTypeScaleView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 05/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestionTypeScaleView.h"

#pragma mark - Class Extension

@interface ELQuestionTypeScaleView ()

@property (nonatomic, strong) NSMutableArray *mOptions;

@end

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
    NSDictionary *formValues;
    BOOL isYesOrNo = _question.answer.type == kELAnswerTypeYesNoScale;
    BOOL isOneToTen = _question.answer.type != kELAnswerTypeOneToFiveScale;
    BOOL isOneToTenWithExplanation = _question.answer.type == kELAnswerTypeOneToTenWithExplanation;
    UIFont *font = Font(@"Lato-Regular", isOneToTen ? 10.0f : 13.0f);
    
    // Segmented Control
    [self.scaleChoices removeAllSegments];
    [self.scaleChoices setTitleTextAttributes:@{NSFontAttributeName: font} forState:UIControlStateNormal];
    
    for (int i = 0; i < [self.mOptions count]; i++) {
        ELAnswerOption *option = self.mOptions[i];
        
        [self.scaleChoices insertSegmentWithTitle:Format(@"%@", option.shortDescription)
                                          atIndex:i
                                         animated:NO];
    }
    
    [self.topConstraint setConstant:!isOneToTenWithExplanation ? 25 : 0];
    [self.scaleChoices updateConstraints];
    
    // Text View
    self.textView.hidden = !isOneToTenWithExplanation;
    
    // Populate question answer
    formValues = [AppSingleton.mSurveyFormDict objectForKey:@(_question.objectId)];
    
    if (!formValues) {
        return;
    }
    
    index = [formValues[@"value"] integerValue] == -1 ? self.mOptions.count : [formValues[@"value"] integerValue];
    
    [self.scaleChoices setSelectedSegmentIndex:isYesOrNo ? index : index - 1];
    [self.textView setText:formValues[@"explanation"]];
}

#pragma mark - Public Methods

- (NSDictionary *)formValues {
    ELAnswerOption *option;
    
    if (!_question.optional && self.scaleChoices.selectedSegmentIndex < 0) {
        return nil;
    }
    
    option = self.mOptions[self.scaleChoices.selectedSegmentIndex];
    
    return @{@"question": @(_question.objectId),
             @"type": @(_question.answer.type),
             @"value": (NSNumber *)option.value,
             @"explanation": self.textView.text};
}

#pragma mark - Getter/Setter Methods

- (ELQuestion *)question {
    return _question;
}

- (void)setQuestion:(ELQuestion *)question {
    _question = question;
    self.mOptions = [NSMutableArray arrayWithArray:_question.answer.options];
    
    if (_question.isNA) {
        [self.mOptions addObject:[[ELAnswerOption alloc] initWithDictionary:@{@"description": @"N/A", @"value": @(-1)}
                                                                      error:nil]];
    }
    
    [self setupNumberScale];
}

#pragma mark - Interface Builder Actions

- (IBAction)onScaleChoicesValueChange:(id)sender {
    [AppSingleton.mSurveyFormDict setObject:[self formValues] forKey:@(_question.objectId)];
}

@end
