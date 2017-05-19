//
//  ELSurveyInfoViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 18/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveyInfoViewController.h"

@implementation ELSurveyInfoViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.titleLabel.text = self.infoDict[@"title"];
    self.evaluationLabel.text = self.infoDict[@"evaluation"];
    self.descriptionTextView.text = self.infoDict[@"description"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

@end
