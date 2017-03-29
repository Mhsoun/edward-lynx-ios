//
//  ELDevelopmentPlanTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDevelopmentPlan.h"

@interface ELDevelopmentPlanTableViewCell : UITableViewCell<ELConfigurableCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIView *circleChartView;
@property (weak, nonatomic) IBOutlet UIView *barChartView;

@end
