//
//  ELInstantFeedbacksViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAnswerInstantFeedbackViewController.h"
#import "ELBaseViewController.h"
#import "ELDataProvider.h"
#import "ELInstantFeedback.h"
#import "ELListViewManager.h"
#import "ELQuestion.h"
#import "ELTableDataSource.h"

@interface ELInstantFeedbacksViewController : ELBaseViewController<UITableViewDataSource, UITableViewDelegate, ELAPIResponseDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
