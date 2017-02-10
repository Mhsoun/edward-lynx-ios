//
//  ELFeedbackViewManager.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELFeedbackViewManager.h"

#pragma mark - Class Extension

@interface ELFeedbackViewManager ()

@property (nonatomic, strong) ELSurveysAPIClient *client;
@property (nonatomic, strong) void (^requestCompletionBlock)(NSURLResponse *response, NSDictionary *responseDict, NSError *error);

@end

@implementation ELFeedbackViewManager

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _client = [[ELSurveysAPIClient alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    self.requestCompletionBlock = ^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [weakSelf.delegate onAPIPostResponseError:error.userInfo];
                
                return;
            }
            
            [weakSelf.delegate onAPIPostResponseSuccess:responseDict];
        });
    };
    
    [self setupValidators];
    
    return self;
}

#pragma mark - Public Methods

- (void)processInstantFeedback:(NSDictionary *)formDict {
    [self.client createInstantFeedbackWithParams:formDict
                                      completion:self.requestCompletionBlock];
}

- (void)processInstantFeedbackAnswerSubmissionAtId:(int64_t)objId
                                      withFormData:(NSDictionary *)formDict {
    [self.client answerInstantFeedbackWithId:objId
                                      params:formDict
                                  completion:self.requestCompletionBlock];
}

- (void)processSharingOfReportToUsers:(NSDictionary *)params atId:(int64_t)objId {
    [self.client shareInstantFeedback:objId
                               params:params
                           completion:self.requestCompletionBlock];
}

- (BOOL)validateCreateInstantFeedbackFormValues:(NSDictionary *)formDict {
    NSString *key;
    NSArray *typeErrors, *questionErrors;
    ELFormItemGroup *formFieldGroup;
    
    key = @"type";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
        typeErrors = [[formDict[key] textValue] isEqualToString:kELNoQuestionType] ? @[NSLocalizedString(@"kELAnswerTypeValidation", nil)] :
                                                                                     nil;
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:typeErrors];
    }
    
    key = @"question";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
        questionErrors = [REValidation validateObject:[formDict[key] textValue]
                                                 name:NSLocalizedString(@"kELQuestionField", nil)
                                           validators:@[@"presence"]];
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:questionErrors];
    }
    
    return questionErrors.count == 0 && typeErrors.count == 0;
}

#pragma mark - Private Methods

- (void)setupValidators {
    [REValidation registerDefaultValidators];
    [REValidation setErrorMessages:[ELAppSingleton sharedInstance].validationDict];
}

@end
