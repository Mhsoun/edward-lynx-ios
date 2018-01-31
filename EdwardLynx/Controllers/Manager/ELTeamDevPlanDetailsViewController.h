//
//  ELTeamDevPlanDetailsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "ELBaseViewController.h"

@interface ELTeamDevPlanDetailsViewController : ELBaseViewController<UITableViewDataSource, UITableViewDelegate, ELAPIResponseDelegate, DZNEmptyDataSetSource>

@property (nonatomic) int64_t devPlanId;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
