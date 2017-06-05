//
//  ELDevelopmentPlanDetailsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 01/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseDetailViewController.h"

@class ELDevelopmentPlan;

@interface ELDevelopmentPlanDetailsViewController : ELBaseDetailViewController<UITableViewDataSource, UITableViewDelegate, ELAPIResponseDelegate, ELDevelopmentPlanGoalDelegate>

@property (strong, nonatomic) ELDevelopmentPlan *devPlan;

@property (weak, nonatomic) IBOutlet UIView *circleChartView;
@property (weak, nonatomic) IBOutlet UILabel *chartLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton *addGoalButton;
- (IBAction)onAddGoalButtonClick:(id)sender;

@end
