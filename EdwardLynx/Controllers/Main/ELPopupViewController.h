//
//  ELPopupViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 07/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIViewController+CWPopup.h>

#import "ELBaseViewController.h"

@interface ELPopupViewController : ELBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

- (IBAction)onButtonClick:(id)sender;

@end
