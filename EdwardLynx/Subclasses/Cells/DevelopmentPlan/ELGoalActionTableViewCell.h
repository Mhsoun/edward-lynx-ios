//
//  ELGoalActionTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 24/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ELGoalAction.h"

static CGFloat const kELIconSize = 20;

@interface ELGoalActionTableViewCell : UITableViewCell<ELConfigurableCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
- (IBAction)onMoreButtonClick:(id)sender;

- (void)updateStatusView:(__kindof UIView *)statusView;

@end
