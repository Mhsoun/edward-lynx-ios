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

@property (nonatomic, strong) void (^apiResponseCompletionBlock)(NSURLResponse *response, NSDictionary *responseDict, NSError *error);

@end

@implementation ELListViewManager

- (instancetype)init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    __weak typeof(self) weakSelf = self;
    
    self.apiResponseCompletionBlock = ^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
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

- (void)processRetrievalOfSurveys {
    [[[ELSurveysAPIClient alloc] init] currentUserSurveysWithCompletion:self.apiResponseCompletionBlock];
}

@end
