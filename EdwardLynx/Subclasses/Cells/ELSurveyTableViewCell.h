//
//  ELSurveyTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurvey.h"

@interface ELSurveyTableViewCell : UITableViewCell<ELConfigurableCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *surveyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusIcon;

@end