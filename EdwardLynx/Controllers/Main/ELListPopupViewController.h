//
//  ELListPopupViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBasePopupViewController.h"

@interface ELListPopupViewController : ELBasePopupViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
- (IBAction)onCancelButtonClick:(id)sender;
- (IBAction)onConfirmButtonClick:(id)sender;

@end
