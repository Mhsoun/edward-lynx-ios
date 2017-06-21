//
//  ELManagerIndividualViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <XLPagerTabStrip-AnthonyMDev/XLBarPagerTabStripViewController.h>

#import "ELBaseViewController.h"

@interface ELManagerIndividualViewController : ELBaseViewController<UITableViewDataSource, UITableViewDelegate, ELManagerItemsDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
