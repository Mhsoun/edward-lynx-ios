//
//  ELRespondentFreeTextTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/02/2018.
//  Copyright © 2018 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELRespondentFreeTextTableViewCell : UITableViewCell<ELConfigurableCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *responseLabel;
@property (weak, nonatomic) IBOutlet UILabel *respondentLabel;

@end
