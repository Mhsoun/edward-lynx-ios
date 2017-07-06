//
//  ELManagerReportsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/07/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <XLPagerTabStrip-AnthonyMDev/XLBarPagerTabStripViewController.h>

#import "ELBaseViewController.h"

@interface ELManagerReportsViewController : ELBaseViewController<UITableViewDataSource, UITableViewDelegate, ELAPIResponseDelegate, DZNEmptyDataSetSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
