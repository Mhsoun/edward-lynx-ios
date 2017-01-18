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

- (void)processRetrievalOfSurveyQuestionsAtId:(int64_t)objId {
    [self.client userSurveyQuestionsForId:objId completion:self.requestCompletionBlock];
}

- (void)processSharingOfReportToUsers:(NSArray *)userIds atId:(int64_t)objId {
    [self.client shareInstantFeedback:objId
                               params:@{@"users": userIds}
                           completion:self.requestCompletionBlock];
}

- (void)processSurveyAnswerSubmissionWithFormData:(NSDictionary *)formDict {
    [self.client submitAnswerForSurveyWithId:self.detailObject.objectId
                                      params:formDict
                                  completion:self.requestCompletionBlock];
}

@end
