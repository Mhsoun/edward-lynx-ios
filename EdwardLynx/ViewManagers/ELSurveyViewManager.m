//
//  ELSurveyViewManager.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <REValidation/REValidation.h>

#import "ELSurveyViewManager.h"
#import "ELSurvey.h"
#import "ELSurveysAPIClient.h"

#pragma mark - Class Extension

@interface ELSurveyViewManager ()

@property (nonatomic, strong) ELSurveysAPIClient *client;
@property (nonatomic, strong) ELSurvey *survey;
@property (nonatomic, strong) void (^requestCompletionBlock)(NSURLResponse *response, NSDictionary *responseDict, NSError *error);

@end

@implementation ELSurveyViewManager

#pragma mark - Lifecycle

- (instancetype)initWithSurvey:(ELSurvey *)survey {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _client = [[ELSurveysAPIClient alloc] init];
    _survey = survey;
    
    __weak typeof(self) weakSelf = self;
    
    self.requestCompletionBlock = ^(NSURLResponse *response,
                                    NSDictionary *responseDict,
                                    NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [weakSelf.delegate onAPIPostResponseError:error.userInfo];
                
                return;
            }
            
            [weakSelf.delegate onAPIPostResponseSuccess:responseDict];
        });
    };
    
    [ELUtils registerValidators];
    
    return self;
}

#pragma mark - Public Methods

- (void)processInviteOthersToRateYouWithParams:(NSDictionary *)formDict {
    [self.client inviteOthersToRateYouWithId:self.survey.objectId
                                      params:formDict
                                  completion:self.requestCompletionBlock];
}

- (void)processSurveyAnswerSubmissionWithFormData:(NSDictionary *)formDict {
    [self.client submitAnswerForSurveyWithId:self.survey.objectId
                                      params:formDict
                                  completion:self.requestCompletionBlock];
}

- (BOOL)validateAddInviteUserFormValues:(NSDictionary *)formDict {
    NSString *key;
    NSArray *emailErrors, *nameErrors;
    ELFormItemGroup *formFieldGroup;
    
    key = @"email";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
        emailErrors = [REValidation validateObject:[formFieldGroup textValue]
                                              name:NSLocalizedString(@"kELEmailField", nil)
                                        validators:@[@"presence", @"email"]];
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:emailErrors];
    }
    
    key = @"name";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
        nameErrors = [REValidation validateObject:[formFieldGroup textValue]
                                             name:NSLocalizedString(@"kELNameField", nil)
                                       validators:@[@"presence"]];
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:nameErrors];
    }
    
    return emailErrors.count == 0 && nameErrors.count == 0;
}

@end
