//
//  ELDetailViewManager.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 04/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDetailViewManager.h"

#pragma mark - Class Extension

@interface ELDetailViewManager ()

@property (nonatomic, strong) ELSurveysAPIClient *client;
@property (nonatomic, strong) void (^requestCompletionBlock)(NSURLResponse *response, NSDictionary *responseDict, NSError *error);

@end

@implementation ELDetailViewManager

#pragma mark - Lifecycle

- (instancetype)initWithDetailObject:(__kindof ELModel *)detailObject {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _client = [[ELSurveysAPIClient alloc] init];
    _detailObject = detailObject;
    
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
    
    return self;
}

#pragma mark - Public Methods

- (void)processRetrievalOfReportDetails {
    [self.client instantFeedbackReportDetailsWithId:self.detailObject.objectId
                                         completion:self.requestCompletionBlock];
}

- (void)processRetrievalOfSurveyQuestions {
    [self.client userSurveyQuestionsForId:self.detailObject.objectId
                               completion:self.requestCompletionBlock];
}

- (void)processSurveyAnswerSubmissionWithFormData:(NSDictionary *)formDict {
    [self.client submitAnswerForSurveyWithId:self.detailObject.objectId
                                      params:formDict
                                  completion:self.requestCompletionBlock];
}

@end
