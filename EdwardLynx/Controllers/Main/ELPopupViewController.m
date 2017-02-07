//
//  ELPopupViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 07/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELPopupViewController.h"

#pragma mark - Class Extension

@interface ELPopupViewController ()

@end

@implementation ELPopupViewController

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super initWithNibName:@"PopupView" bundle:nil];
    
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.useBlurForPopup = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Interface Builder Actions

- (IBAction)onButtonClick:(id)sender {
    [self dismissPopupViewControllerAnimated:YES completion:nil];
}

@end
