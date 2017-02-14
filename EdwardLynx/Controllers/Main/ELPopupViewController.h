//
//  ELPopupViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 07/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBasePopupViewController.h"

@interface ELPopupViewController : ELBasePopupViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

- (IBAction)onButtonClick:(id)sender;

@end
