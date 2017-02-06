//
//  ELDevelopmentPlanDetailsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 01/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseDetailViewController.h"
#import "ELDetailViewManager.h"
#import "ELDevelopmentPlan.h"
#import "ELDevelopmentPlanAPIClient.h"
#import "ELGoalTableViewCell.h"

@interface ELDevelopmentPlanDetailsViewController : ELBaseDetailViewController<UITableViewDataSource, UITableViewDelegate, ELAPIResponseDelegate>

@property (strong, nonatomic) ELDevelopmentPlan *devPlan;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
