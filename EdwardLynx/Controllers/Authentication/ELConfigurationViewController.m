//
//  ELConfigurationViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELConfigurationViewController.h"
#import "ELCategory.h"
#import "ELLeftMenuViewController.h"
#import "ELInstantFeedback.h"
#import "ELOAuthInstance.h"
#import "ELParticipant.h"
#import "ELQuestionsAPIClient.h"
#import "ELSurveysAPIClient.h"
#import "ELUsersAPIClient.h"

#pragma mark - Private Constants

static NSInteger const kELAPICallsNumber = 3;

#pragma mark - Class Extension

@interface ELConfigurationViewController ()

@property (nonatomic) NSInteger index;
@property (nonatomic, strong) void (^apiCallBlock)(NSError *);

@end

@implementation ELConfigurationViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    __weak typeof(self) weakSelf = self;
    
    self.index = 1;
    self.apiCallBlock = ^(NSError *error) {
        ELLeftMenuViewController *controller;
        
        if (error) {
            [weakSelf.indicatorView stopAnimating];
            
            return;
        }
        
        weakSelf.index++;
        
        if (weakSelf.index <= kELAPICallsNumber) {
            [weakSelf fetchDataFromAPI];
            
            return;
        }
        
        controller = [[UIStoryboard storyboardWithName:@"LeftMenu" bundle:nil]
                      instantiateInitialViewController];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [weakSelf presentViewController:controller
                               animated:YES
                             completion:^{
            [weakSelf.indicatorView stopAnimating];
        }];
    };
    
    // Fetch all necessary data from API
    [self fetchDataFromAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Private Methods

- (void)fetchDataFromAPI {
    switch (self.index) {
        case 1:
            [self fetchUserProfileFromAPIWithCompletion:self.apiCallBlock];
            
            break;
        case 2:
            [self fetchUsersFromAPIWithCompletion:self.apiCallBlock];
            
            break;
        case 3:
            [self fetchQuestionCategoriesFromAPIWithCompletion:self.apiCallBlock];
            
            break;
        default:
            break;
    }
}

- (void)fetchQuestionCategoriesFromAPIWithCompletion:(void (^)(NSError *))completion {
    [[[ELQuestionCategoriesAPIClient alloc] init] categoriesOfUserWithCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *mCategories = [[NSMutableArray alloc] init];
            
            for (NSDictionary *categoryDict in responseDict[@"items"]) {
                [mCategories addObject:[[ELCategory alloc] initWithDictionary:categoryDict error:nil]];
            }
            
            AppSingleton.categories = [mCategories copy];
            
            completion(error);
        });
    }];
}

- (void)fetchUserProfileFromAPIWithCompletion:(void (^)(NSError *))completion {
    [[[ELUsersAPIClient alloc] init] userInfoWithCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error || responseDict[@"error"]) {
                [self reloginUserCredentialsWithCompletion:^(NSError *loginError) {
                    if (loginError) {
                        return;
                    }
                    
                    DLog(@"%@: Re-login successful", [self class]);
                    
                    [self fetchUserProfileFromAPIWithCompletion:completion];
                }];
                
                return;
            }
            
            [AppSingleton setUser:[[ELUser alloc] initWithDictionary:responseDict error:nil]];
            
            completion(error);
        });
    }];
}

- (void)fetchUsersFromAPIWithCompletion:(void (^)(NSError *))completion {
    [[[ELUsersAPIClient alloc] init] retrieveUsersWithCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *mParticipants = [[NSMutableArray alloc] init];
            
            for (NSDictionary *participantDict in responseDict[@"items"]) {
                ELParticipant *participant = [[ELParticipant alloc] initWithDictionary:participantDict
                                                                                 error:nil];
                
                [participant setIsAddedByEmail:NO];
                [participant setIsAlreadyInvited:NO];
                [mParticipants addObject:participant];
            }
            
            AppSingleton.participants = [mParticipants copy];
            
            completion(error);
        });
    }];
}

- (void)reloginUserCredentialsWithCompletion:(void (^)(NSError *))completion {
    NSDictionary *credentials = [ELUtils getUserDefaultsObjectForKey:kELAuthCredentialsUserDefaultsKey];
    
    [[[ELUsersAPIClient alloc] init] loginWithUsername:credentials[@"username"]
                                              password:credentials[@"password"]
                                            completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Store authentication details in a custom object
        [ELUtils setUserDefaultsCustomObject:[[ELOAuthInstance alloc] initWithDictionary:responseDict error:nil]
                                         key:kELAuthInstanceUserDefaultsKey];
        
        completion(error);
    }];
}

@end
