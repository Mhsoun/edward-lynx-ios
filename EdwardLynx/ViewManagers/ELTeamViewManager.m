//
//  ELTeamViewManager.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 22/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELTeamViewManager.h"
#import "ELTeamAPIClient.h"

#pragma mark - Class Extension

@interface ELTeamViewManager ()

@property (nonatomic, strong) ELTeamAPIClient *client;
@property (nonatomic, strong) void (^requestCompletionBlock)(NSURLResponse *response, NSDictionary *responseDict, NSError *error);
@property (nonatomic, strong) void (^postRequestCompletionBlock)(NSURLResponse *response, NSDictionary *responseDict, NSError *error);

@end

@implementation ELTeamViewManager

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _client = [[ELTeamAPIClient alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    self.requestCompletionBlock = ^(NSURLResponse *response,
                                    NSDictionary *responseDict,
                                    NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [weakSelf.delegate onAPIResponseError:error.userInfo];
                
                return;
            }
            
            [weakSelf.delegate onAPIResponseSuccess:responseDict];
        });
    };
    self.postRequestCompletionBlock = ^(NSURLResponse *response,
                                        NSDictionary *responseDict,
                                        NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [weakSelf.postDelegate onAPIPostResponseError:error.userInfo];
                
                return;
            }
            
            [weakSelf.postDelegate onAPIPostResponseSuccess:responseDict];
        });
    };
    
    [ELUtils registerValidators];
    
    return self;
}

#pragma mark - Public Methods

- (void)processEnableUsersForManagerDashboard:(NSDictionary *)params {
    [self.client enableUsersWithParams:params completion:self.postRequestCompletionBlock];
}

- (void)processRetrieveSharedUserDevPlans {
    [self.client linkedUsersDevPlansWithParams:nil completion:self.requestCompletionBlock];
}

- (void)processRetrieveUsersWithSharedDevPlans {
    [self.client linkedUsersDevPlansWithParams:@{@"type": @"sharing"} completion:self.requestCompletionBlock];
}

@end
