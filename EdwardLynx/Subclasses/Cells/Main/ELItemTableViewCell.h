//
//  ELItemTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 18/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

@interface ELItemTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ELItemCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
- (IBAction)onDeleteButtonClick:(id)sender;
- (IBAction)onEditButtonClick:(id)sender;

@end
