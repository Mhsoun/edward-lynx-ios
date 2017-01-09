//
//  ELParticipantTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 09/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELParticipant.h"

@interface ELParticipantTableViewCell : UITableViewCell<ELConfigurableCellDelegate, ELRowHandlerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusIcon;

@end
