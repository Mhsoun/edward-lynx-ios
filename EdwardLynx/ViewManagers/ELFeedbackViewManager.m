//
//  ELFeedbackViewManager.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <REValidation/REValidation.h>

#import "ELFeedbackViewManager.h"
#import "ELSurveysAPIClient.h"

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
    
    [ELUtils registerValidators];
    
    return self;
}

#pragma mark - Public Methods

- (void)processInstantFeedback:(NSDictionary *)formDict {
    [self.client createInstantFeedbackWithParams:formDict
                                      completion:self.requestCompletionBlock];
}

- (void)processInstantFeedbackAddParticipantsWithId:(int64_t)objId formData:(NSDictionary *)formDict {
    [self.client addInstantFeedbackParticipantsWithId:objId
                                               params:formDict
                                           completion:self.requestCompletionBlock];
}

- (void)processInstantFeedbackAnswerSubmissionWithId:(int64_t)objId formData:(NSDictionary *)formDict {
    [self.client answerInstantFeedbackWithId:objId
                                      params:formDict
                                  completion:self.requestCompletionBlock];
}

- (void)processInviteOthersToRateYouWithId:(int64_t)objId formData:(NSDictionary *)formDict {
    // TODO API call
}

- (void)processSharingOfReportToUsersWithId:(int64_t)objId formData:(NSDictionary *)formDict {
    [self.client shareInstantFeedbackWithId:objId
                                     params:formDict
                                 completion:self.requestCompletionBlock];
}

- (BOOL)validateCreateInstantFeedbackFormValues:(NSDictionary *)formDict {
    NSArray *errors;
    ELFormItemGroup *formFieldGroup;
    NSString *key = @"question";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
        errors = [REValidation validateObject:[formDict[key] textValue]
                                         name:NSLocalizedString(@"kELQuestionField", nil)
                                   validators:@[@"presence"]];
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:errors];
    }
    
    return errors.count == 0;
}

@end
