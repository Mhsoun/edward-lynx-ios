//
//  ELReportDetailsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBasePageChildViewController.h"

@class ELInstantFeedback;

@interface ELReportDetailsViewController : ELBasePageChildViewController<UITableViewDataSource, UITableViewDelegate, ELAPIResponseDelegate>

@property (strong, nonatomic) NSDictionary *infoDict;
@property (strong, nonatomic) __kindof ELModel *selectedObject;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *moreBarButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *tableContainerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *anonymousLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIView *averageContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *averageHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *averageChartView;
@property (weak, nonatomic) IBOutlet UIView *indexContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indexHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *indexChartView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedbackDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedbackInfoLabel;
- (IBAction)onMoreBarButtonClick:(UIBarButtonItem *)sender;

@end
