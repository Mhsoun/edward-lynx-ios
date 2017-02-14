//
//  ELDetailViewManager.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 04/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDetailViewManager.h"
#import "ELDevelopmentPlanAPIClient.h"
#import "ELSurveysAPIClient.h"

#pragma mark - Class Extension

@interface ELDetailViewManager ()

@property (nonatomic) int64_t objectId;
@property (nonatomic, strong) ELDevelopmentPlanAPIClient *devPlanClient;
@property (nonatomic, strong) ELSurveysAPIClient *surveyClient;
@property (nonatomic, strong) __kindof ELModel *detailObject;
@property (nonatomic, strong) void (^requestCompletionBlock)(NSURLResponse *response, NSDictionary *responseDict, NSError *error);

@end

@implementation ELDetailViewManager

#pragma mark - Lifecycle

- (instancetype)initWithDetailObject:(__kindof ELModel *)detailObject {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _devPlanClient = [[ELDevelopmentPlanAPIClient alloc] init];
    _surveyClient = [[ELSurveysAPIClient alloc] init];
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

- (instancetype)initWithObjectId:(int64_t)objectId {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _devPlanClient = [[ELDevelopmentPlanAPIClient alloc] init];
    _surveyClient = [[ELSurveysAPIClient alloc] init];
    _objectId = objectId;
    
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

- (void)processRetrievalOfDevelopmentPlanDetails {
    [self.devPlanClient developmentPlanWithId:!self.detailObject ? self.objectId : self.detailObject.objectId
                               withCompletion:self.requestCompletionBlock];
}

- (void)processRetrievalOfInstantFeedbackDetails {
    [self.surveyClient instantFeedbackWithId:!self.detailObject ? self.objectId : self.detailObject.objectId
                                  completion:self.requestCompletionBlock];
}

- (void)processRetrievalOfReportDetails {
    [self.surveyClient instantFeedbackReportDetailsWithId:!self.detailObject ? self.objectId : self.detailObject.objectId
                                               completion:self.requestCompletionBlock];
}

- (void)processRetrievalOfSurveyDetails {
    [self.surveyClient userSurveyWithId:!self.detailObject ? self.objectId : self.detailObject.objectId
                             completion:self.requestCompletionBlock];
}

- (void)processRetrievalOfSurveyQuestions {
    [self.surveyClient userSurveyQuestionsWithId:!self.detailObject ? self.objectId : self.detailObject.objectId
                                      completion:self.requestCompletionBlock];
}

@end
