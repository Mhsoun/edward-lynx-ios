//
//  ELGoalTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 01/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

static CGFloat const kELActionCellHeight = 60;

@interface ELGoalTableViewCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate, ELConfigurableCellDelegate>

@property (strong, nonatomic) id<ELDevelopmentPlanGoalDelegate> delegate;
@property (strong, nonatomic) NSString *devPlanName;

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
