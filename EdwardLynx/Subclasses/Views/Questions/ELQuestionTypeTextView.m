//
//  ELQuestionTypeTextView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestionTypeTextView.h"

@implementation ELQuestionTypeTextView

#pragma mark - Lifecycle

- (instancetype)init {
    return [super initWithNibName:@"QuestionTypeTextView"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Public Methods

- (NSDictionary *)formValues {
    // TODO Handle isNA questions
//    return @{@"question": @(self.question.objectId),
//             @"answer": self.question.isNA ? @(-1) : self.textView.text};
    
    return @{@"question": @(self.question.objectId),
             @"answer": self.textView.text};
}

@end
