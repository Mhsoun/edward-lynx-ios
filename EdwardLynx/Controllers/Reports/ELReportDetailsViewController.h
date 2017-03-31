//
//  ELReportDetailsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"

@class ELInstantFeedback;

@interface ELReportDetailsViewController : ELBaseViewController<ELAPIResponseDelegate>

@property (nonatomic, strong) ELInstantFeedback *instantFeedback;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareBarButton;
@property (weak, nonatomic) IBOutlet UIView *averageBarChartView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *averageHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *indexBarChartView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indexHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
- (IBAction)onShareBarButtonClick:(id)sender;

@end
