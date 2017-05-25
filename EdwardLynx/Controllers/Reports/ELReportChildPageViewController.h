//
//  ELReportChildPageViewController.h
//  
//
//  Created by Jason Jon E. Carreos on 25/05/2017.
//
//

#import "ELBasePageChildViewController.h"

@interface ELReportChildPageViewController : ELBasePageChildViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
