//
//  ELListViewManager.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 04/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELListViewManager.h"
#import "ELAPIClient.h"
#import "ELDevelopmentPlanAPIClient.h"
#import "ELSurveysAPIClient.h"

#pragma mark - Class Extension

@interface ELListViewManager ()

@property (nonatomic, strong) ELAPIClient *client;
@property (nonatomic, strong) ELDevelopmentPlanAPIClient *devPlanClient;
@property (nonatomic, strong) ELSurveysAPIClient *surveyClient;
@property (nonatomic, strong) void (^requestCompletionBlock)(NSURLResponse *response, NSDictionary *responseDict, NSError *error);

@end

@implementation ELListViewManager

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _client = [[ELAPIClient alloc] init];
    _surveyClient = [[ELSurveysAPIClient alloc] init];
    _devPlanClient = [[ELDevelopmentPlanAPIClient alloc] init];
    
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

- (void)processRetrievalOfDevelopmentPlans {
    [self.devPlanClient currentUserDevelopmentPlansWithCompletion:self.requestCompletionBlock];
}

- (void)processRetrievalOfInstantFeedbacks {
    [self.surveyClient currentUserInstantFeedbacksWithFilter:@"to_answer"
                                                  completion:self.requestCompletionBlock];
}

- (void)processRetrievalOfPaginatedListAtLink:(NSString *)link page:(NSInteger)page {
    [self.client getRequestAtLink:link
                      queryParams:@{@"page": @(page)}
                       completion:self.requestCompletionBlock];
}

- (void)processRetrievalOfReports {
    [self.surveyClient currentUserInstantFeedbacksWithFilter:@"mine"
                                                  completion:self.requestCompletionBlock];
}

- (void)processRetrievalOfSurveys {
    [self.surveyClient currentUserSurveysWithQueryParams:nil
                                              completion:self.requestCompletionBlock];
}

@end
