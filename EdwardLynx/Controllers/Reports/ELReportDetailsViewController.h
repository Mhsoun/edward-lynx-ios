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

@property (strong, nonatomic) __kindof ELModel *selectedObject;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareBarButton;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *averageChartView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *averageIndicatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *averageHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *indexContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indexHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *indexChartView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indexIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
- (IBAction)onShareBarButtonClick:(id)sender;

@end
