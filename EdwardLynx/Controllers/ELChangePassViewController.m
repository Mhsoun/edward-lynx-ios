//
//  ELChangePassViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELChangePassViewController.h"

#pragma mark - Private Constants

static CGFloat const kICornerRadius = 4.0f;

@interface ELChangePassViewController ()

@end

@implementation ELChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods

- (void)layoutPage {
    // Fields
    self.currentPasswordView.layer.cornerRadius = kICornerRadius;
    self.passwordView.layer.cornerRadius = kICornerRadius;
    self.confirmPasswordView.layer.cornerRadius = kICornerRadius;
}

#pragma mark - Interface Builder Actions

- (IBAction)onDoneClick:(id)sender {

}

@end
