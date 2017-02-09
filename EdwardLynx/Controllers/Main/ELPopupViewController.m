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

@property (nonatomic, strong) NSDictionary *detailsDict;
@property (nonatomic, strong) __kindof ELBaseViewController *controller;

@end

@implementation ELPopupViewController

#pragma mark - Lifecycle

- (instancetype)initWithPreviousController:(__kindof ELBaseViewController *)controller
                                   details:(NSDictionary *)detailsDict {
    self = [super initWithNibName:@"PopupView" bundle:nil];
    
    if (!self) {
        return nil;
    }
    
    _controller = controller;
    _detailsDict = detailsDict;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.useBlurForPopup = NO;
    
    [self setupPopupDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)setupPopupDetails {
    self.titleLabel.text = self.detailsDict[@"title"];
    self.headerLabel.text = self.detailsDict[@"header"];
    self.detailLabel.text = self.detailsDict[@"details"];
}

#pragma mark - Interface Builder Actions

- (IBAction)onButtonClick:(id)sender {
    if (self.controller.popupViewController) {
        [self.controller dismissPopupViewControllerAnimated:YES completion:nil];
    }
}

@end
