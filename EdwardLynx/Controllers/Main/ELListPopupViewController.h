//
//  ELListPopupViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBasePopupViewController.h"

@interface ELListPopupViewController : ELBasePopupViewController<UITableViewDelegate>

@property (weak, nonatomic) id<ELListPopupDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
