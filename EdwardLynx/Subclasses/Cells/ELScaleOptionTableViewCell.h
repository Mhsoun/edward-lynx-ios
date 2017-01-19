//
//  ELScaleOptionTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 18/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

@interface ELScaleOptionTableViewCell : UITableViewCell

@property (strong, nonatomic) id<ELScaleOptionCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
- (IBAction)onDeleteButtonClick:(id)sender;

@end
