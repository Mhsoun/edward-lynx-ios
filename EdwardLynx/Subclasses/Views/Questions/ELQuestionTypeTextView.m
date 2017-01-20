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
}

#pragma mark - Public Methods

- (NSDictionary *)formValues {
    if (!_question.optional && self.textView.text.length == 0) {
        return nil;
    }
    
    return @{@"question": @(self.question.objectId),
             @"answer": self.textView.text};
}

- (ELQuestion *)question {
    return _question;
}

- (void)setQuestion:(ELQuestion *)question {
    _question = question;
    
    self.helpLabel.text = _question.answer.help;
}

@end
