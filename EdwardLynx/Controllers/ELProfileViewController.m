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

@end

@implementation ELProfileViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Populate with user information
    [self populatePage];
}

#pragma mark - Private Methods

- (void)populatePage {
    ELUser *user = [ELAppSingleton sharedInstance].user;
    
    self.nameLabel.text = user.name;
    self.emailLabel.text = user.email;
    self.infoLabel.text = user.info;
}

@end
