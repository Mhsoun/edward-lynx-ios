//
//  ELInstantFeedback.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELInstantFeedback.h"
#import "ELQuestion.h"

@implementation ELInstantFeedback

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id",
                                                                  @"question": @"questions"}];
}

- (void)setQuestionWithNSArray:(NSArray *)questions {
    if (questions.count == 0) {
        self.question = nil;
        
        return;
    }
    
    self.question = [[ELQuestion alloc] initWithDictionary:questions[0] error:nil];
}

@end
