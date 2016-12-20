//
//  ELProfileViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELProfileViewController.h"

@interface ELProfileViewController ()

@end

@implementation ELProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[[ELUsersAPIClient alloc] init] userInfoWithCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.nameLabel.text = responseDict[@"name"];
            self.emailLabel.text = responseDict[@"email"];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
