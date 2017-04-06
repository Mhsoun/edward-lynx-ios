//
//  ELReportTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELLabel.h"

@interface ELReportTableViewCell : UITableViewCell<ELConfigurableCellDelegate, ELRowHandlerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nextIcon;

@property (weak, nonatomic) IBOutlet ELLabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *invitedIcon;
@property (weak, nonatomic) IBOutlet UILabel *invitedLabel;

@end
