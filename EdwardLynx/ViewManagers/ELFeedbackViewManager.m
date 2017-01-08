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
static NSString * const kELNoParticipantRole = @"No role selected";

#pragma mark - Class Extension

@interface ELFeedbackViewManager ()

@property (nonatomic, strong) void (^requestCompletionBlock)(NSURLResponse *response, NSDictionary *responseDict, NSError *error);

@end

@implementation ELFeedbackViewManager

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    __weak typeof(self) weakSelf = self;
    
    self.requestCompletionBlock = ^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [weakSelf.delegate onAPIResponseError:error.userInfo];
                
                return;
            }
            
            [weakSelf.delegate onAPIResponseSuccess:responseDict];
        });
    };
    
    [self setupValidators];
    
    return self;
}

#pragma mark - Public Methods

- (void)processInstantFeedback:(NSDictionary *)formDict {
    [[[ELSurveysAPIClient alloc] init] createInstantFeedbackWithParams:formDict
                                                            completion:self.requestCompletionBlock];
}

- (BOOL)validateCreateInstantFeedbackFormValues:(NSDictionary *)formDict {
    NSString *key;
    NSArray *typeErrors, *questionErrors;
    ELFormItemGroup *formFieldGroup;
    
    key = @"type";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
        typeErrors = [[formDict[key] textValue] isEqualToString:kELNoQuestionType] ? @[@"A question type should be selected"] : nil;
        
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

- (BOOL)validateInstantFeedbackInviteUsersFormValues:(NSDictionary *)formDict {
    NSString *key;
    NSArray *nameErrors,
            *emailErrors,
            *roleErrors;
    ELFormItemGroup *formFieldGroup;
    
    key = @"name";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
        nameErrors = [REValidation validateObject:[formDict[key] textValue]
                                             name:@"Name"
                                       validators:@[@"presence"]];
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:nameErrors];
    }
    
    key = @"email";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
        emailErrors = [REValidation validateObject:[formDict[key] textValue]
                                              name:@"Email"
                                        validators:@[@"presence", @"email"]];
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:emailErrors];
    }
    
    key = @"role";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
        roleErrors = [[formDict[key] textValue] isEqualToString:kELNoParticipantRole] ? @[@"A role should be selected"] : nil;
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:roleErrors];
    }
    
    return nameErrors.count == 0 &&
           emailErrors.count == 0 &&
           roleErrors.count == 0;
}

#pragma mark - Private Methods

- (void)setupValidators {
    [REValidation registerDefaultValidators];
    [REValidation registerDefaultErrorMessages];
}

@end
