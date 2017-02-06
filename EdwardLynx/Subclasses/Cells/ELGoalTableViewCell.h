//
//  ELGoalTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 01/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "AppDelegate.h"
#import "ELDevelopmentPlanAPIClient.h"
#import "ELGoal.h"

@interface ELGoalTableViewCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate, ELConfigurableCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
