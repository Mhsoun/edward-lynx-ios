//
//  ELBasePopupViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBasePopupViewController.h"

@implementation ELBasePopupViewController

- (instancetype)initWithPreviousController:(__kindof UIViewController *)controller
                                   details:(NSDictionary *)detailsDict {
    // TODO Implementation is per subclass
    
    return [super init];
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

- (void)dealloc {
    DLog(@"%@", [self class]);
}

@end
