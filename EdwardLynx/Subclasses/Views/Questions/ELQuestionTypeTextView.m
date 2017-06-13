//
//  ELQuestionTypeTextView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestionTypeTextView.h"

@implementation ELQuestionTypeTextView

@synthesize question = _question;

#pragma mark - Lifecycle

- (instancetype)init {
    return [super initWithNibName:@"QuestionTypeTextView"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textView.delegate = self;
}

#pragma mark - Protocol Methods (UITextView)

- (void)textViewDidChange:(UITextView *)textView {
    [AppSingleton.mSurveyFormDict setObject:[self formValues] forKey:@(_question.objectId)];
}

#pragma mark - Public Methods

- (NSDictionary *)formValues {
    return @{@"question": @(self.question.objectId),
             @"type": @(self.question.answer.type),
             @"value": self.textView.text};
}

#pragma mark - Getter/Setter Methods

- (ELQuestion *)question {
    return _question;
}

- (void)setQuestion:(ELQuestion *)question {
    NSDictionary *formValues;
    
    _question = question;
    
    // Populate question answer
    formValues = [AppSingleton.mSurveyFormDict objectForKey:@(_question.objectId)];
    
    if (formValues) {
        self.textView.text = formValues[@"value"];
    }
}

@end
