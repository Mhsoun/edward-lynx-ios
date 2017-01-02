//
//  ELQuestionTypeTextView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestionTypeTextView.h"

@implementation ELQuestionTypeTextView

- (instancetype)initWithFormKey:(NSString *)key {
    return [super initWithNibName:[NSString stringWithFormat:@"%@View", kELQuestionTypeText]
                         valueKey:key];
}

- (NSDictionary *)formValues {
    return @{};
}

@end
