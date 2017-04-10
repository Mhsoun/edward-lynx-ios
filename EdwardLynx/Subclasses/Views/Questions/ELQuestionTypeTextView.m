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
    [AppSingleton.mSurveyFormDict setObject:[self formValues]
                                     forKey:@(_question.objectId)];
}

#pragma mark - Public Methods

- (NSDictionary *)formValues {
//    if (!_question.optional && self.textView.text.length == 0) {
//        return nil;
//    }
    
    return @{@"question": @(self.question.objectId),
             @"answer": self.textView.text};
}

#pragma mark - Getter/Setter Methods

- (ELQuestion *)question {
    return _question;
}

- (void)setQuestion:(ELQuestion *)question {
    _question = question;
    
    // Populate question answer
    if (_question.value && _question.value.length > 0) {
        self.textView.text = _question.value;
    }
}

@end
