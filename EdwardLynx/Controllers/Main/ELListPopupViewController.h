//
//  ELListPopupViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIViewController+CWPopup.h>

#import "ELBasePopupViewController.h"
#import "ELListTableViewCell.h"

@interface ELListPopupViewController : ELBasePopupViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
- (IBAction)onConfirmButtonClick:(id)sender;

@end
