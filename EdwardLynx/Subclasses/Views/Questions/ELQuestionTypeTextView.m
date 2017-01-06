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

- (instancetype)initWithFormKey:(NSString *)key {
    return [super initWithNibName:@"QuestionTypeTextView" valueKey:key];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Public Methods

- (NSDictionary *)formValues {
    return @{};
}

@end
