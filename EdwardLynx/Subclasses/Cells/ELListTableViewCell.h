//
//  ELListTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

@class ELFilterSortItem;

@interface ELListTableViewCell : UITableViewCell<ELConfigurableCellDelegate, ELRowHandlerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) ELFilterSortItem *item;

@end
