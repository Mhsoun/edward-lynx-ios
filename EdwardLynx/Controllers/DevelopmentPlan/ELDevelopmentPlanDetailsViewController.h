//
//  ELDevelopmentPlanDetailsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 01/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELDevelopmentPlan.h"
#import "ELGoalTableViewCell.h"

@interface ELDevelopmentPlanDetailsViewController : ELBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) ELDevelopmentPlan *devPlan;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
