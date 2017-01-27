//
//  ELBaseViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 13/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"

#pragma mark - Class Extension

@interface ELBaseViewController ()

@end

@implementation ELBaseViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                                         style:UIBarButtonItemStylePlain
                                                                                                        target:nil
                                                                                                        action:nil];
    
    [[UIBarButtonItem appearance] setTintColor:[[RNThemeManager sharedManager] colorForKey:kELOrangeColor]];
    
    // Subclass-specific UI-related additions
    [self layoutPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods

- (void)layoutPage {
    // NOTE Implementation is per subclass
}

@end
