//
//  ELTeamDevPlanDetailsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"

@interface ELTeamDevPlanDetailsViewController : ELBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *goals;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
