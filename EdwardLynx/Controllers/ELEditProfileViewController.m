//
//  ELEditProfileViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELEditProfileViewController.h"

#pragma mark - Private Constants

static CGFloat const kICornerRadius = 4.0f;

#pragma mark - Class Extension

@interface ELEditProfileViewController ()

@end

@implementation ELEditProfileViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self populatePage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)populatePage {
    self.nameTextField.text = self.userInfoDict[@"name"];
    self.infoTextField.text = self.userInfoDict[@"info"];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    // Fields
    self.nameView.layer.cornerRadius = kICornerRadius;
    self.infoView.layer.cornerRadius = kICornerRadius;
}

#pragma mark - Interface Builder Actions

- (IBAction)onDoneClick:(id)sender {
    // TODO Action
}

@end
