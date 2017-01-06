//
//  ELFeedbackViewManager.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELFeedbackViewManager.h"

#pragma mark - Private Constants

static NSString * const kELNoQuestionType = @"No type selected";

@implementation ELFeedbackViewManager

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    [self setupValidators];
    
    return self;
}

#pragma mark - Public Methods

- (BOOL)validateCreateInstantFeedbackFormValues:(NSDictionary *)formDict {
    NSString *key;
    NSArray *typeErrors, *questionErrors;
    ELFormItemGroup *formFieldGroup;
    
    key = @"type";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
        typeErrors = [[formDict[@"type"] textValue] isEqualToString:kELNoQuestionType] ? @[@"A question type should be selected"] : nil;
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:typeErrors];
    }
    
    key = @"question";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
        questionErrors = [REValidation validateObject:[formDict[key] textValue]
                                                 name:@"Question"
                                           validators:@[@"presence"]];
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:questionErrors];
    }
    
    return questionErrors.count == 0 && typeErrors.count == 0;
}

#pragma mark - Private Methods

- (void)setupValidators {
    [REValidation registerDefaultValidators];
    [REValidation registerDefaultErrorMessages];
}

@end
