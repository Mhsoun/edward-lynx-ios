//
//  ELProfileViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELProfileViewController.h"

#pragma mark - Class Extension

@interface ELProfileViewController ()

@property (nonatomic, strong) NSDictionary *userInfoDict;  // NOTE Should be a custom model class

@end

@implementation ELProfileViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[[ELUsersAPIClient alloc] init] userInfoWithCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.nameLabel.text = responseDict[@"name"];
            self.emailLabel.text = responseDict[@"email"];
            
            self.userInfoDict = responseDict;
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditProfile"]) {
        ELEditProfileViewController *controller = [segue destinationViewController];
        
        controller.userInfoDict = self.userInfoDict;
    }
}

@end
