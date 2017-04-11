//
//  ELDashboardViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 16/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"

@interface ELDashboardViewController : ELBaseViewController<UITableViewDataSource, UITableViewDelegate, ELDashboardViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
