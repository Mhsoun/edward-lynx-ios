//
//  ELListViewManager.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 04/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELListViewManager.h"

#pragma mark - Class Extension

@interface ELListViewManager ()

@property (nonatomic, strong) ELSurveysAPIClient *client;
@property (nonatomic, strong) void (^requestCompletionBlock)(NSURLResponse *response, NSDictionary *responseDict, NSError *error);

@end

@implementation ELListViewManager

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
                [weakSelf.delegate onAPIResponseError:error.userInfo];
                
                return;
            }
            
            [weakSelf.delegate onAPIResponseSuccess:responseDict];
        });
    };
    
    return self;
}

- (void)processRetrievalOfInstantFeedbacks {
    [self.client currentUserInstantFeedbacksWithFilter:@"to_answer"
                                            completion:self.requestCompletionBlock];
}

- (void)processRetrievalOfReports {
    [self.client currentUserInstantFeedbacksWithFilter:@"mine"
                                            completion:self.requestCompletionBlock];
}

- (void)processRetrievalOfSurveys {
    [self.client currentUserSurveysWithCompletion:self.requestCompletionBlock];
}

@end
