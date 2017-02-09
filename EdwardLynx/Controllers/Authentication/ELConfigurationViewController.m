//
//  ELConfigurationViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELConfigurationViewController.h"

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
        if (error) {
            [weakSelf.indicatorView stopAnimating];
            
            return;
        }
        
        weakSelf.index++;
        
        if (weakSelf.index <= kELAPICallsNumber) {
            [weakSelf fetchDataFromAPI];
            
            return;
        }
        
        [weakSelf presentViewController:[[UIStoryboard storyboardWithName:@"LeftMenu" bundle:nil]
                                         instantiateInitialViewController]
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
        case 4:
            [self fetchUserInstantFeedbacksFromAPIWithCompletion:self.apiCallBlock];
            
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
            
            [ELAppSingleton sharedInstance].categories = [mCategories copy];
            
            completion(error);
        });
    }];
}

- (void)fetchUserInstantFeedbacksFromAPIWithCompletion:(void (^)(NSError *))completion {
    [[[ELSurveysAPIClient alloc] init] currentUserInstantFeedbacksWithFilter:@"to_answer"
                                                                  completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *mInstantFeedbacks = [[NSMutableArray alloc] init];
            
            for (NSDictionary *instantFeedbackDict in responseDict[@"items"]) {
                [mInstantFeedbacks addObject:[[ELInstantFeedback alloc] initWithDictionary:instantFeedbackDict error:nil]];
            }
            
            [ELAppSingleton sharedInstance].instantFeedbacks = [mInstantFeedbacks copy];
            
            completion(error);
        });
    }];
}

- (void)fetchUserProfileFromAPIWithCompletion:(void (^)(NSError *))completion {
    [[[ELUsersAPIClient alloc] init] userInfoWithCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ELAppSingleton sharedInstance] setUser:[[ELUser alloc] initWithDictionary:responseDict
                                                                                  error:nil]];
            
            completion(error);
        });
    }];
}

- (void)fetchUsersFromAPIWithCompletion:(void (^)(NSError *))completion {
    [[[ELUsersAPIClient alloc] init] retrieveUsersWithCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *mParticipants = [[NSMutableArray alloc] init];
            
            for (NSDictionary *participantDict in responseDict[@"items"]) {
                ELParticipant *participant = [[ELParticipant alloc] initWithDictionary:participantDict error:nil];
                
                [participant setIsAddedByEmail:NO];
                [mParticipants addObject:participant];
            }
            
            [ELAppSingleton sharedInstance].participants = [mParticipants copy];
            
            completion(error);
        });
    }];
}

@end
