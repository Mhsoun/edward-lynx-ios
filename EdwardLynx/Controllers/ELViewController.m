//
//  ELViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELViewController.h"
#import "ELAPIClient.h"

#pragma mark - Private Constants

static CGFloat const kICornerRadius = 2.0f;

@interface ELViewController ()

@end

@implementation ELViewController

#pragma mark - Lifecycle

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
    CAGradientLayer *gradient;
    
    // Fields
    self.usernameView.layer.cornerRadius = kICornerRadius;
    self.passwordView.layer.cornerRadius = kICornerRadius;
    
    // Button
    self.loginButton.layer.cornerRadius = kICornerRadius;
    
    // View
    gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[RNThemeManager sharedManager] colorForKey:@"darkVioletColor"].CGColor,
                       (id)[[RNThemeManager sharedManager] colorForKey:@"violetColor"].CGColor,
                       nil];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
}

@end
